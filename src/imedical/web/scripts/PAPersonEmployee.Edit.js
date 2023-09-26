// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 02.03.05

function DocumentLoadHandler() {
    var obj=document.getElementById("EPEDesc");
    if (obj) obj.onblur=EPEDescBlurHandler;
    var obj=document.getElementById("PAPEREmployeeNo");
    if (obj) obj.onblur=PAPEREmployeeNoBlurHandler;

    UpdateFields();
}

// disable and enable fields based on Employee Type
function UpdateFields() {
    var obj=document.getElementById("EPECode");
    if (obj) {
        if (obj.value=="DEMP") {
            // Direct Employee
            DisableAllFields(1,",update1,EPEDesc,PAPERJobTitle,CTCODesc,CONTCode,PAPEREmployeeNo,CTLOCDesc,PAPEREmployeeDateFrom,PAPEREmployeeDateTo,PAPEREmployeeGrade,PAPEROccupation,CTOCCDesc,",1);
            EnableField("PAPERJobTitle");
            EnableField("CTCODesc");
            EnableLookup("ld2050iCTCODesc");
            EnableField("CONTCode");
            EnableLookup("ld2050iCONTCode");
            EnableField("PAPEREmployeeNo");
            // hide employee number lookup for direct employees
            var obj=document.getElementById("ld2050iPAPEREmployeeNo");
            if (obj) obj.style.visibility="hidden";

            EnableField("CTLOCDesc");
            EnableLookup("ld2050iCTLOCDesc");
            var obj=document.getElementById("PAPERName");
            if (obj) obj.innerText="";
            
            // cjb 06/07/2006 59761
            EnableField("PAPEREmployeeDateFrom");
            EnableLookup("ld2050iPAPEREmployeeDateFrom");
            EnableField("PAPEREmployeeDateTo");
            EnableLookup("ld2050iPAPEREmployeeDateTo");
            EnableField("PAPEREmployeeGrade");
            
        
        } else if (obj.value=="REMP") {
            // Relation of Employee
            DisableAllFields(1,",update1,EPEDesc,CTRLTDesc,PAPEREmployeeNo,CTLOCDesc,",1);
            EnableField("CTRLTDesc");
            EnableLookup("ld2050iCTRLTDesc");
            EnableField("PAPEREmployeeNo");
            var obj=document.getElementById("ld2050iPAPEREmployeeNo");
            if (obj) obj.style.visibility="";
            EnableLookup("ld2050iPAPEREmployeeNo");
            EnableField("CTLOCDesc");
            DisableLookup("ld2050iCTLOCDesc");
            var obj=document.getElementById("CTLOCDesc");
            if (obj) {
                obj.disabled=true;
            }
            
        } else if (obj.value=="NOT") {
            // Not Relevant
            DisableAllFields(1,",update1,EPEDesc,CTCODesc,CONTCode,CTEMFDesc,PAPERTelO,",1);
            EnableField("CTCODesc");
            EnableLookup("ld2050iCTCODesc");
            EnableField("CONTCode");
            EnableLookup("ld2050iCONTCode");
            EnableField("CTEMFDesc");
            EnableLookup("ld2050iCTEMFDesc");
            EnableField("PAPERTelO");
            var obj=document.getElementById("PAPERName");
            if (obj) obj.innerText="";
        } else {
            DisableAllFields(1,",update1,EPEDesc,",1);
            var obj=document.getElementById("PAPERName");
            if (obj) obj.innerText="";
        }
    }
}

function EPEDescLookup(str) {
    var lu=str.split("^");
    var obj=document.getElementById("EPECode");
    if (obj) obj.value=lu[2];
    
    // clear out previous details
    if (lu[2]=="DEMP") {
        var obj=document.getElementById("PAPEREmployeeNo");
        if (obj) obj.value="";
        var obj=document.getElementById("CTLOCDesc");
        if (obj) obj.value="";
    }
    
    UpdateFields();
}

function EPEDescBlurHandler() {
    var obj=document.getElementById("EPEDesc");
    var objcode=document.getElementById("EPECode");
    if ((obj)&&(objcode)&&(obj.value=="")) objcode.value="";
    UpdateFields();
}

function PAPEREmployeeNoLookup(str) {
    var lu=str.split("^");
    var obj=document.getElementById("PAPERName");
    if ((obj)&&(lu[1]+lu[2]!="")) obj.innerText=lu[1]+", "+lu[2];
    var obj=document.getElementById("CTLOCDesc");
    var objcode=document.getElementById("EPECode");
    if ((obj)&&(objcode)&&(objcode.value="REMP")) obj.innerText=lu[4];
    //if (obj) obj.innerText=lu[4];
    
    // for direct employees, show error if employee number already in use
    if (lu[5]=="Y") {
        alert(t["EmplNoInUse"]);
        var obj=document.getElementById("PAPEREmployeeNo");
        if (obj) obj.value="";
        websys_setfocus("PAPEREmployeeNo");
    }
}

function PAPEREmployeeNoBlurHandler() {
    var obj=document.getElementById("PAPEREmployeeNo");
    if ((obj)&&(obj.value=="")) {
        var obj2=document.getElementById("CTLOCDesc")
        if (obj2) obj2.value="";
        var obj2=document.getElementById("PAPERName")
        if (obj2) obj2.innerText="";
    }
}

document.body.onload=DocumentLoadHandler;