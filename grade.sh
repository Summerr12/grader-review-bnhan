CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission    #ListExamples was cloned into student submission/ I need to move .java to grading area
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

# javac GradeServer.java
file_name=`find student-submission -name "*.java"`
echo $file_name

if [[ $file_name != "student-submission/ListExamples.java" ]]
then
    echo "File is not the correct file"
    exit 1
fi

cp TestListExamples.java grading-area #Moved test file into grading area

cd student-submission
pwd
cp ListExamples.java ../grading-area #grading area is outside student submissions

cd ../grading-area #sends me to parent

#go out of grading area to use junit hamcrest by ../ before lib
javac -cp .:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar *.java
java -cp .:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > error.txt

# Check if the number of lines in error.txt is less than 2
if [[ "$(wc -l < error.txt)" -lt 9 ]]; then
    # If true, exit the script or take other appropriate actions
    echo "100%, amazing!"
    exit 
fi


if [[ -s error.txt ]] #if its not empty
then
    tail -n 2 error.txt > lastline.txt
    cat lastline.txt
    awk '{print substr($0, index($0, "example") + 12, 1)}' lastline.txt > firstindex.txt
    awk '{print substr($0, index($0, "example") + 26, 1)}' lastline.txt > secondindex.txt
  
    result=$(expr $(cat firstindex.txt) - $(cat secondindex.txt))
    results=$(expr $result / $(cat firstindex.txt))
    echo "The score is: $results"
    echo "the student got $(cat secondindex.txt) out of $(cat firstindex.txt)"

fi


