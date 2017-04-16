//
//  main.cpp
//  scheduler
//
//  Created by Marek Černý on 14/04/2017.
//  Copyright © 2017 Marek Cerny. All rights reserved.
//

#include "scheduler.hpp"
#include <iostream>

int main(int argc, const char** argv) {
    
    scheduler::Tests t{std::cout};
    t.runAll();
    
    return 0;
}
