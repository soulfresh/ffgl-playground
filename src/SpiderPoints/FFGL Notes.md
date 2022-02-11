# Questions

- Why does the hostTime jump between the first and second ProcessOpenGL calls?
- What is the intended usage of LogToHost?

#  FFGL Notes

## OpenGL Calls
- Plugins should only change the OpenGL state inside the ProcessGL function. Otherwise your plugin can crash the host.

## Parameter types and how to use them

## Timing
- Use the hostTime property of your plugin instance

## Debugging
How do we view the logs while the application is running in Resolume?
