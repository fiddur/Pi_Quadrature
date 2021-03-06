;  Calculation of π using quadrature.
;
;  Copyright © 2013–2015  Russel Winder

(defproject Pi_Quadrature_Clojure "0.0.0-SNAPSHOT"
  :description "A collection of functions to calculate π by quadrature with various realizations."
  :url "https://github.com/russel/Pi_Quadrature"
  :license {:name "GPL v.3"
            :url "http://www.gnu.org/licenses/gpl.html"}
  :dependencies [[org.clojure/clojure "1.7.0"]]
  :source-paths ["src/clojure"]
  :java-source-paths ["src/java"]
  :javac-options ["-target" "1.8" "-source" "1.8"]
)
