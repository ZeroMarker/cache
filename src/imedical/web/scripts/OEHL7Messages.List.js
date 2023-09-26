//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 39327 - AI - 15-10-2003: Created this js file to handle the variable DisableProperties.

var OEHL7MessagesListForm=document.forms["fOEHL7Messages_List"];

function BodyLoadHandler() {
	var objDisable=document.getElementById('DisableProperties');
	if ((objDisable),(objDisable.value=="1")) {
        var fields=new Array("Update","UserCode","PIN","cPIN","cUserCode");
        for (var i=0;i<fields.length;i++) {
            var objUpdate=document.getElementById(fields[i]);
            if (objUpdate) {
                objUpdate.style.visibility="hidden";
            }
        }

		if (OEHL7MessagesListForm) {
			var OEHL7MessagesListTable=OEHL7MessagesListForm.document.getElementById("tOEHL7Messages_List");
			if (OEHL7MessagesListTable) {
				for (var i=1; i<OEHL7MessagesListTable.rows.length; i++) {
					var objAck=OEHL7MessagesListForm.document.getElementById("Acknowledgez"+i);
					if (objAck) {
						objAck.disabled = true;
						objAck.checked=false;
						objAck.className = "disabledField";
					}
				}
			}
		}
	}
}

// Log 56923 - AI - 06-01-2006 : Function to select / deselect all "Acknowledge" checkboxes on the page.
var objSelectAll = OEHL7MessagesListForm.elements["SelectAll"];
if (objSelectAll) objSelectAll.onclick=SelectAllClickHandler;

function SelectAllClickHandler(evt) {
	// Get the table of the same name as the form.
	var OEHL7MessagesListTbl=document.getElementById("tOEHL7Messages_List");

	// Set each "Acknowledge" checkbox to the same value as the "SelectAll" checkbox.
	if (OEHL7MessagesListTbl) {
		for (var curr_row=1; curr_row<OEHL7MessagesListTbl.rows.length; curr_row++) {
			var objSelectItem=OEHL7MessagesListForm.elements["Acknowledgez" + curr_row];
			if (objSelectItem) objSelectItem.checked=objSelectAll.checked;
		}
	}

	return true;
}
// end Log 56923

document.body.onload=BodyLoadHandler;