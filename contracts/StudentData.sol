// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

// Stores and returns basic details about students.
contract StudentData {

    // A structure groups the details belonging to one student.
    struct Student {
        uint256 rollNo;
        string name;
        uint256 age;
        string course;
    }

    // Dynamic array that stores all student records.
    // 'public' automatically creates a getter for individual array entries.
    Student[] public students;

    // Adds a new student record to the end of the students array.
    // 'memory' is temporary memory used for string inputs during this function call.
    function addStudent(
        uint256 _rollNo,
        string memory _name,
        uint256 _age,
        string memory _course
    ) public {
        students.push(
            Student(
                _rollNo,
                _name,
                _age,
                _course
            )
        );
    }

    // Returns the total number of student records stored in the array.
    function getStudentCount() public view returns (uint256) {
        return students.length;
    }

    // Returns all details of the student at the given array index.
    // Array indexing starts from 0, so the first student is at index 0.
    function getStudent(uint256 _index)
        public
        view
        returns (
            uint256 rollNo,
            string memory name,
            uint256 age,
            string memory course
        )
    {
        // Copy the selected student record into memory for reading.
        Student memory s = students[_index];

        // Return the four fields separately.
        return (
            s.rollNo,
            s.name,
            s.age,
            s.course
        );
    }

    // Runs when a call reaches the contract but no function matches the call data.
    // 'payable' allows this fallback function to receive Ether.
    fallback() external payable {
        // No additional action is performed here.
    }

    // Runs when Ether is sent to this contract with empty call data.
    // 'payable' allows the contract to receive that Ether.
    receive() external payable {
        // No additional action is performed here.
    }
}
