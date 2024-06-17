    // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TodoList{

    struct ToDo{
        string text;
        bool   completed;
    }

    ToDo[] public todos;

    function create(string calldata _text,bool _completed) external {
        ToDo memory one = ToDo({text:_text,completed:_completed});
        todos.push(one);
    }



    function updateText(uint idx,string calldata _text) external{
        todos[idx].text = _text;
    }

     function oggleCompleted(uint idx) external{
        todos[idx].completed = !todos[idx].completed;
     }
}