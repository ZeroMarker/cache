var preRowInd=0;
window.onload = function()
{
   var code = document.getElementById("code");
   var name = document.getElementById("name");
   var btnAdd = document.getElementById("add");
   if(btnAdd)
   {
      btnAdd.onclick = function()
      {
         if( ! nameNotNull(name.value)) return;

         var addHidden = document.getElementById("addHidden");
         if( ! addHidden) return;

         runServerMethod(addHidden.value, "",code.value, name.value);
      }
   }

   var btnUpdate = document.getElementById("update");

   if(btnUpdate)
   {
      btnUpdate.onclick = function()
      {
         if( ! rowSelected()) return;

         if( ! nameNotNull(name.value)) return;

         if( ! name.idVal) return;

         var updateHidden = document.getElementById("updateHidden");
         if( ! updateHidden) return;

         runServerMethod(updateHidden.value, name.idVal, code.value, name.value);
      }
   }

   var btnDelete = document.getElementById("delete");

   if(btnDelete)
   {
      btnDelete.onclick = function()
      {
         if( ! rowSelected()) return;

         if( ! name.idVal) return;

         var deleteHidden = document.getElementById("deleteHidden");
         if( ! deleteHidden) return;

         runServerMethod(deleteHidden.value, name.idVal);
      }
   }

}

function nameNotNull(nameValue)
{
   if( ! nameValue)
   {
      alert(t["nameNotNull"]);
      return false;
   }

   return true;
}

function SelectRowHandler()
{
   var eSrc = window.event.srcElement;
   var objtbl = document.getElementById('tDHCCLHospital');
   var rows = objtbl.rows.length;
   var lastrowindex = rows - 1;
   var rowObj = getRow(eSrc);
   var selectrow = rowObj.rowIndex;

   objtbl.selectrow = selectrow;
   
   var code = document.getElementById("code");
   var name = document.getElementById("name");
   var tCode = document.getElementById("tCodez" + selectrow);
   var tName = document.getElementById("tNamez" + selectrow);
   var rowId = document.getElementById("tRowIdz" + selectrow);
   if(tCode)
   {
      code.value = tCode.innerText;
   }
   if(tName && rowId)
   {
      name.value = tName.innerText;
      name.idVal = rowId.innerText;
   }
   
   if (preRowInd==selectrow)
   {
	   code.value = "";
	   name.value = "";
	   preRowInd=0;
   }
   else
   {
	   preRowInd=selectrow;
   }
}

function rowSelected()
{
   var objtbl = document.getElementById('tDHCCLHospital');

   if( objtbl && ! objtbl.selectrow)
   {
      alert(t["selectRow"]);
      return false;
   }
   return true;
}

function runServerMethod(method, rowId, code, name)
{
   var result = "";
   if(arguments.length == 2)
   {
      result = cspRunServerMethod(method, rowId);
   }
   else
   {
      result = rowId ? cspRunServerMethod(method, rowId, code, name) : cspRunServerMethod(method, code, name);
   }


   if(result != "0")
   {
      alert(result);
      return;
   }

   self.location.reload();
}
