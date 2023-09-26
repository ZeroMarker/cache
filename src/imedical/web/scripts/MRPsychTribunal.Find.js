// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 17.03.05


function AppealTypeLookup(str) {
    var lu=str.split("^");
    var obj=document.getElementById("Appeal");
    if (obj) obj.value=lu[3];
}