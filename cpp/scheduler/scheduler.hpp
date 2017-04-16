//
//  scheduler.hpp
//  scheduler
//
//  Created by Marek Černý on 14/04/2017.
//  Copyright © 2017 Marek Cerny. All rights reserved.
//

#ifndef scheduler_hpp
#define scheduler_hpp

#include <iostream>
#include <fstream>
#include <iomanip>
#include <string>
#include <cassert>
#include <unordered_map>
#include <vector>
#include <utility>
#include <sstream>
#include <array>
#include <stack>

namespace scheduler {
    
    constexpr auto kHours = 16;
    constexpr auto kDays = 10;
    constexpr auto kDayName = {
        "mon", "tue", "wed", "thu", "fri",
        "mon", "tue", "wed", "thu", "fri",
    };
    
    std::string dayToString(unsigned day) {
        const std::vector<const char*> lookup = kDayName;
        return lookup.at(day);
    }
    
    struct Slot {
        static const auto min_hour = 1u;
        static const auto max_hour = 16u;
        unsigned day, hour;
    };
    
    struct Event {
        std::vector<Slot> slots;
        std::string teacher;
    };
    
    struct Subject {
        std::vector<Event> events;
        std::string name;
    };
    
    using VecCPtrSubj = std::vector<const Subject*>;
    using VecCPtrSubjIt = std::vector<const Subject*>::iterator;
    using CVecEvent = const std::vector<Event>;
    using CVecEventIt = std::vector<Event>::const_iterator;
    using PairStep = std::pair<VecCPtrSubjIt, CVecEventIt>;
    template <typename T>
    using SchedArray = std::array<std::array<T, kHours>, kDays>;
    
    /*
     class InputReader:
     Reading input as it is served by parse.php part.
     
     */
    class InputReader {
    public:
        
        explicit InputReader(std::istream &is) : is_{is} {}
        
        std::vector<Subject> readSubjects() {
//            std::string s; is_ >> s; std::cout << s;
            skip("data(");
            skipContentBetween('[', ']'); skip(","); // day-weights
            skipContentBetween('[', ']'); skip(",");  // hour-weights
            skipContentBetween('[', ']'); skip(",");  // teachers
            
            std::vector<Subject> result;
            
            skip("[");
            for (;;) {
                auto r = readSubject();
                if (!r.second) break;
                result.emplace_back( std::move(r.first));
            }
            skip("]");
            skip(")");
            return result;
        }
        
    private:
        
        void skip(const std::string& s) {
            for (char c: s) {
                char rc = 0; is_ >> rc;
                if (rc != c) {
                    throw std::invalid_argument{std::string{"Wrong read: "} + c};
                }
            }
        }
        
        void skipSpaces() {
            while ( is_ && std::isspace(is_.peek()) ) is_.get();
        }
        
        bool trySkip(const std::string& s) {
            for (char c: s) {
                skipSpaces();
                if (is_.peek() != c) return false;
                is_.get();
            }
            return true;
        }
        
        void skipContentBetween(char beg, char end) {
            skip(std::string{} + beg);
            for (char c; is_ && is_.peek() != end; is_.get(c)) {}
            skip(std::string{} + end);
        }
        
        std::pair<Subject, bool> readSubject() {
            Subject subj;
            if (!trySkip("[")) return {subj, false};
            is_ >> std::quoted(subj.name);
            skip(",");
            skip("[");
            for (;;) {
                auto r = readEvent();
                if (!r.second) break;
                subj.events.emplace_back( std::move(r.first));
            }
            skip("]");
            skip("]");
            trySkip(",");
            return {subj, true};
        }
        
        std::pair<Event, bool> readEvent() {
            Event event;
            if (!trySkip("[")) return {event, false};
            skip("[");
            for (;;) {
                auto r = readSlot();
                if (!r.second) break;
                event.slots.emplace_back( std::move(r.first));
            }
            skip("]");
            skip(",");
            is_ >> std::quoted(event.teacher);
            skip("]");
            trySkip(",");
            return {event, true};
        }
        
        std::pair<Slot, bool> readSlot() {
            Slot slot;
            if (!trySkip("dt(")) {
                return {slot, false};
            }
            std::string day(3, '#');
            for (char &d: day) is_ >> d;
            skip(",");
            const std::unordered_map<std::string, unsigned> table {
                {"mon", 0}, {"tue", 1}, {"wed", 2}, {"thu", 3}, {"fri", 4}
            };
            auto it = table.find(day);
            if (it == table.end()) {
                throw std::invalid_argument{"Bad day '" + day + "'"};
            }
            slot.day = it->second;
            is_ >> slot.hour;
            
            if (slot.hour < Slot::min_hour || Slot::max_hour < slot.hour) {
                throw std::invalid_argument{"Bad hour '" + std::to_string(slot.hour) + "'"};
            }
            skip(")");
            trySkip(",");
            return {slot, true};
        }
        
        std::istream& is_;
    };
    
    class StackPrinter {
    public:
        StackPrinter(std::ostream& os) : os_{os} {}
        
        void printSchedule(const std::vector<PairStep>& stack) {
            resetTable();
            for (const PairStep& ps: stack) {
                for (const Slot& s: ps.second->slots) {
                    table_[s.day][s.hour] = &ps;
                }
            }
            
            const std::string line(80, '-');
            os_ << line << std::endl;
            for (int d=0; d < kDays; ++d) {
                for (int h=0; h < kHours; ++h) {
                    os_ << std::setw(6);
                    if (table_.at(d).at(h) != nullptr) {
                        const Subject* ptr = *table_.at(d).at(h)->first;
                        os_ << ptr->name;
                    } else {
                        os_ << "";
                    }
                }
                os_ << std::endl;
            }
            os_ << line << std::endl;
        }
        
    private:
        
        void resetTable() {
            for (auto&& row: table_) {
                std::fill(row.begin(), row.end(), nullptr);
            }
        }
        
        SchedArray<const PairStep*> table_;
        std::ostream& os_;
    };
    
    
    class Scheduler {
    public:
        template<typename TVecSubjs>
        Scheduler(TVecSubjs&& subjs) : subjs_{std::forward<TVecSubjs>(subjs)} {
            state_ = State::INIT;
            for (auto& l: table_) {
                std::fill(l.begin(), l.end(), false);
            }
        }
        
        auto yieldAllPos() {
            bool valid = doStep();
            return std::pair<const std::vector<PairStep>&, bool>(step_stack_, valid);
        }
        
        auto&& stack() {
            return step_stack_;
        }
        
    private:
        
        enum class State : char {INIT='i', YIEALDING='y'};

        bool doStep() {
            switch (state_) {
                case State::INIT:
                    state_ = State::YIEALDING;
                    initStep();
                    // fallthrough
                case State::YIEALDING:
                    return nextStep();
            }
        }
        
        void initStep() {
            selected_.reserve(subjs_.size());
            for (const Subject& subj: subjs_) {
                selected_.push_back( &subj );
            }
            
            std::sort(selected_.begin(), selected_.end(), [](const Subject* s, const Subject* t) {
                return s->events.size() < t->events.size();
            });
            
            assert(!selected_.empty());
            step_stack_.emplace_back(selected_.begin(), (**selected_.begin()).events.end());
        }
        
        bool nextStep() {
            while (!step_stack_.empty()) {
                VecCPtrSubjIt sit;
                CVecEventIt eit;
                std::tie(sit, eit) = step_stack_.back();
                // delete me
                if (eit != (**sit).events.end()) {
                    std::for_each(eit->slots.begin(), eit->slots.end(), [&t=table_](const Slot& s) {
                        t.at(s.day).at(s.hour) = false;
                    });
                }
                
                step_stack_.pop_back();
                
                while (eit-- != (**sit).events.begin()) {
                    
                    bool isconflict = std::any_of(eit->slots.begin(), eit->slots.end(),
                                                  [&t=table_] (const Slot& s) {
                                                      return t.at(s.day).at(s.hour);
                                                  });
                    if (!isconflict) {
                        // sounds good, step in
                        step_stack_.emplace_back(sit, eit);
                        // all placed
                        if (sit+1 == selected_.end()) {
                            return true;
                        }
                        //
                        std::for_each(eit->slots.begin(), eit->slots.end(),
                                      [&t=table_](const Slot& s) {
                                          t.at(s.day).at(s.hour) = true;
                                      });
                        step_stack_.emplace_back(sit+1, (**(sit+1)).events.end());
                        break;
                    }
                }
                
            }
            return false;
        }
        
        State state_;
        const std::vector<Subject> subjs_;
        // TODO: replace with vector<bool>
        std::array<std::array<bool, kHours>, kDays> table_;
        VecCPtrSubj selected_;
        std::vector<PairStep> step_stack_;
    };
    
    
    /*
     class Tests;
     - for unit testing
     */
    class Tests {
    public:
        Tests(std::ostream& os) : os_{os} {}
        
        void runAll() {
            os_ << "Tests started" << std::endl;
//            readInput();
            testDays();
            testScheduler();
        }
        void readInput() {
            std::ifstream ifs{"/Users/marekcerny/Semestral/cpp/scheduler/tests/tmpfile.txt"};
            InputReader r{ifs};
            auto subjs = r.readSubjects();
            for (auto&& subj: subjs) {
                os_ << subj.name << std::endl;
                for (auto&& e: subj.events) {
                    os_ << "\t" << e.teacher << " ";
                    for (auto&& slot: e.slots) {
                        os_ << "(" << slot.day << ", "  << slot.hour << ") ";
                    }
                    os_ << std::endl;
                }
            }
        }
        
        void testDays() {
            assert( dayToString(3) == "thu" );
            assert( dayToString(7) == "wed" );
        }
        
        void testScheduler() {
            std::ifstream ifs{"/Users/marekcerny/Semestral/cpp/scheduler/tests/tmpfile.txt"};
            InputReader r{ifs};
            auto subjs = r.readSubjects();
            Scheduler sched{std::vector<Subject>{subjs.begin(), subjs.end()}};
            
            StackPrinter sp{std::cout};
            for (int i=0;; ++i) {
                
                do { std::cout << "Press enter..\n"; } while (std::cin.get() != '\n');
                auto r = sched.yieldAllPos();
                if (!r.second)
                    break;
                sp.printSchedule(r.first);
            }
        }
        
    private:
        std::ostream& os_;
    };
    
};

#endif /* scheduler_hpp */
