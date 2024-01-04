import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './index.css'
import { ThemeProvider, createTheme } from "@material-tailwind/react";

const theme = {
  button: {
    styles: {
      backgroundColor: 'pink'
    }
  },
  body: {
    styles: {
      fontFamily: 'Poppins, sans-serif !important',
    }
  }

};

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <ThemeProvider theme={theme}>
      <App />
    </ThemeProvider>
  </React.StrictMode>,
)
