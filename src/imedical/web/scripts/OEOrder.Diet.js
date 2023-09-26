// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// Log 61464 - Need to move loadhandler out of csp file and into js to allow custom bodyload to fire correctly.

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;