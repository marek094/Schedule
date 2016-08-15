#!/usr/bin/env php
<?php 7;
error_reporting(E_ALL | E_STRICT);


class Process {
    private $url;

    public function __construct(/* func_get_args */) {
        $this->url = call_user_func_array([$this,'makeURL'], func_get_args());
        #var_dump( $this->url) ;
        #echo $this->timeToLesson(640);
    }
    private function makeURL($subj, $settings) {
        return 'https://is.cuni.cz/studium/rozvrhng/roz_predmet_macro.php?predmet=' . 
            $subj . '&skr=' . $settings->skr . '&sem=' . $settings->sem .
            '&fak=' . $settings->fak . '&csv=1';
    }
    private function sisCvsParse($str) {
        static $MASK = ['id','subid','code','name','day','time',null,'size',null,null,null,null,'teacher'];
        $str = trim($str);
        $lines = explode("\n", $str);
        array_shift($lines);
        $res = array_map( function($a) use ($MASK) {return array_combine($MASK, explode(';',$a));} , $lines);
        return $res;
    }
    private function getStructured($arr) {
        $PREF = 'c';
        $res = [];
        foreach ($arr as $row) {
            $subj =& $res[ (preg_match("/x[0-9]+$/", $row['id']) ? $PREF:'') . $row['code'] ];
            $subj[ $row['id'] ][] = $row;
        }
        return $res;
    }
    public function process2() {
        $cont = file_get_contents( $this->url );
        # obscure encoding needs obscure function
        $cont = iconv('CP1250', 'UTF-8', $cont);
        $arr = $this->sisCvsParse( $cont );
        //# C++ like sort by lesson id
        //usort($arr, function($a,$b){return $a['id'] <=> $b['id'];});
        $res = $this->getStructured($arr);
        return $res;
    }
}
    
abstract class Export {
    protected $settings;
    protected $teachers = [];
    abstract public function output($data);
    
    public function __construct($s) {
        $this->settings = $s;
    }
    public function myTeachers(array $new_teachers = null) : array{
        //return array_keys($this->teachers);
        if (is_null($new_teachers)) { #get
            return $this->teachers;
        } else { #set
            $this->teachers = $new_teachers;
        }
    }
    public function getSettings() {
        $this->settings->teachers = array_merge($this->settings->teachers, $this->teachers);
        return $this->settings;
    }
    protected function normalize(string $str) : string {
        return strtr($str,
            "áčďéěíľňóřšťúůýžÁČĎÉĚÍĽŇÓŘŠŤÚŮÝŹ",
            "acdeeilnorstuuyzACDEEILNORSTUUYZ");
    }
    protected function normalizeTeacher(string $prof_one) : string {
        # ová - ová --> ová-ová
        $prof_one = mb_ereg_replace("\s*-\s*",'-', $prof_one);
        $prof_one = mb_ereg_replace(",[^,]+\.,",',', $prof_one);
        $prof_one = mb_ereg_replace(",[^,]+\.$", '', $prof_one);
        /*$names = explode(', ', $prof_one);
        foreach ($names as $name) {
            # title
            if (mb_substr($name, -1, 1) == '.') continue;
            $name_parts = explode(' ', $name);
            $last_name = array_shift($name_parts);
            $name_parts = array_map(function($a){return mb_substr($a,0,1);}, $name_parts);
            $name_parts[] = $last_name;
            $ones[] = implode('. ', $name_parts);
            $ones[] = $name;
        }
        return implode(', ', $ones);*/
        return $prof_one;
    }
    protected function shortName(string $name) : string {
        $NUM = array_flip(['I','II','III','IV','V','VI']);
        $name = trim($name);
        $parts = explode(' ', $name);
        $result = "";
        foreach ($parts as $val) {
            if ($val == "") continue;
            if (isset($NUM[ $val ])) {
                if (mb_strlen($result) > 3) {
                    # HeLLo --> [h,e,l,l,o]
                    $replace_lower = preg_split('//u', strtolower($result), null, PREG_SPLIT_NO_EMPTY);
                    $result = str_replace($replace_lower, '', $result);
                    $result = mb_substr($result, 0, 3);
                    $result .= $val;
                } else {
                    $result .= ' ' . $val;
                }
            } elseif (mb_strlen($val) <= 3) {
                $result .= mb_substr($val, 0, 1);
            } else {
                $result .= mb_strtoupper(mb_substr($val, 0, 1));
            }
        }
        //$result = $this->normalize($result);
        return $result;
    }
    protected function timeToLesson($time) : int {
        $time = (int) $time;
        $time -= 7*60+20; # 7:20
        $time /= 50;
        # for strange times, like IPS
        $time = round($time);
        return $time;
    }
}
    
class PrologExport extends Export {
    private function pTime($time_m, $size_m, $day) {
        static $DAY = ['','mon','tue','wed','thu','fri'];
        $time = $this->timeToLesson($time_m);
        $size = $size_m / 45;
        $res = [];
        for ($i=0;$i<$size;$i++) {
            $ti = $time+$i;
            # Prolog modul specific
            if (0 < $ti && $ti <= 16) {
                $res[] = 'dt(' . $DAY[$day] . ',' . ($ti) . ')';
            }
        }
        return $res;
    }
    private function listTeachers() {
        $res = [];
        foreach ($this->teachers as $teacher => $rank) {
            $res[] = "\"$teacher\"-$rank";
        }
        //var_dump( $this->teachers );
        return $res;
    }
    private function listSubj($data) {
        $subj_list = [];
        # subj ~ NMAI057
        foreach ($data as $subj => $subj_row) {
            $id_list = [];
            # id ~ 15aNMAI057p1
            foreach ($subj_row as $id => $id_row) {
                $times = [];
                # subid ~ 15aNMAI057p1bb
                foreach ($id_row as $subid => $subid_row) {
                    $times = array_merge($times, $this->pTime($subid_row['time'], $subid_row['size'], $subid_row['day']));
                }
                if (count($times) == 0) continue;
                $teacher = $this->normalizeTeacher( $id_row[0]['teacher'] );
                $id_list[] = '[[' . implode(',', $times) . '], "' . $teacher . '"]';

                # sideeffect for $this->listTeachers()
                # save 'used' teachers, 100 is default
                $this->teachers[ $teacher ] = $this->settings->teachers[ $teacher ] ?? 100;
            }
            $subj_short = (preg_match("/x[0-9]+$/", reset($subj_row)[0]['id']) ? 'c':'') . $this->shortName( reset($subj_row)[0]['name'] );
            $subj_list[] = '["' . $subj_short . '", [' . implode(",\n", $id_list) . ']]';
        }
        return $subj_list;
    }
    private function listDay() { return ['1-0', '2-0', '3-1.2', '4-1.2', '5-1.5', '6-1.6', '7-1.2', '11-0.7', '12-0.6', '13-0.6', '15-0', '16-0'];}
    private function listWeek() { return ['mon-0.7', 'tue-1.1', 'wed-1.3', 'thu-1', 'fri-0.7'];}
    public function output($data) {
        $lsls[0] = $this->listWeek();
        $lsls[1] = $this->listDay();
        $lsls[3] = $this->listSubj($data); # need to run further - sideefects
        $lsls[2] = $this->listTeachers();
        ksort($lsls);
        $lsstr = array_map(function($ls) {return '[' . implode(',', $ls) . ']';}, $lsls);
        return "data(" . implode(',', $lsstr) . ").\n";
    }
}

class Application {
    protected $settings;

    public function __construct($argv) {
        fprintf(STDERR, "Running '%s'.. \n", $argv[0]);
        $this->mySettings();
          
        fprintf(STDERR, "Downloading data from 'SIS UK'..\n"); 
        
        unset($argv[0]);
        $data = $this->loadSubjects($argv);
       
        fprintf(STDERR, "Genering data for Prolog..\n");
        $export = new PrologExport($this->settings);
        $prolog = $export->output( $data );
        
        $this->settings = $export->getSettings();
        $this->mySettings($this->settings);
        
        //$prolog = $this->dataForProlog( $data );
        file_put_contents("tmpfile.txt", $prolog);
        
        fprintf(STDERR, "Running Prolog..\n");
        `swipl -s ./main.pl <tmpfile.txt >/dev/tty`;
        
        fprintf(STDERR, "The end.\n");
        //*/
    }
    private function loadSubjects($subjs) {
        $data = [];
        foreach ($subjs as $subjId) {
            $proc = new Process($subjId, $this->settings);
            $data = array_merge( $data, $proc->process2() );
        }
        return $data;
    }
    private function mySettings($new_settings = null) {
        $FILE = $_SERVER['HOME'] . '/.Scheduler_2.conf.json';
        if (is_null($new_settings)) { #get
            $this->settings = $defaults = (object) [
            'fak' => 11320,
            'skr' => 2015,
            'sem' => 1,
            'teachers' => []
            ];
            if ( !file_exists($FILE) ) {
                @file_put_contents(
                                   $FILE,
                                   json_encode($defaults, JSON_PRETTY_PRINT) . PHP_EOL
                                   ) or fprintf(STDERR, "Error in creating config file\n");
            } else {
                $s_json = @file_get_contents( $FILE ) or
                fprintf(STDERR, "Error in reading config file\n");
                # object only on the highest level
                $this->settings = (object) json_decode( $s_json, $assoc = true );
            }
        } else { #set
            arsort($new_settings->teachers);
            $this->settings = $new_settings;
            @file_put_contents(
                               $FILE,
                               json_encode($new_settings, JSON_PRETTY_PRINT) . PHP_EOL
                               ) or fprintf(STDERR, "Error in creating config file\n");
            //echo json_encode($new_settings, JSON_PRETTY_PRINT);
        }
    }
}

    new Application($argv);

    
    
    
    
    
    
    
    
    
    
    
    

