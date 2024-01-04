// pythonRunner.js
const { spawn } = require('child_process');

const pythonScripts = ['park.py', 'testpython.py'];

function runPythonScript(scriptName) {
    const pythonProcess = spawn('python3.8', ['python_scripts/' + scriptName]);
  
    pythonProcess.stdout.on('data', (data) => {
      console.log(`Python Output (${scriptName}): ${data}`);
    });
  
    pythonProcess.stderr.on('data', (data) => {
      console.error(`Python Error (${scriptName}): ${data}`);
    });
  
    pythonProcess.on('close', (code) => {
      console.log(`Python process (${scriptName}) exited with code ${code}`);
    });
  }

  for (const script of pythonScripts) {
    runPythonScript(script);
  }

module.exports = { runPythonScript };
