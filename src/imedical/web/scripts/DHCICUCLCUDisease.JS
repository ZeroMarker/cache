var clcUDRowId="" // 行id
var ctlocId="" //科室ID

function BodyLoadHandler()
{
	var obj=document.getElementById("Insert");
	if(obj) {obj.onclick=InsertClick;}
	var obj=document.getElementById("Update");
	if(obj) {obj.onclick=UpdateClick;}
    var obj = document.getElementById("Delete");
    if(obj){obj.onclick = deleteClick;}

	var ctlocobj=document.getElementById("Ctloc")
	if(ctlocobj)
	{
	   ctlocobj.onblur = function(){
            if(!ctlocobj.value)
            {
                ctlocobj.idVal = "";
            }
       }
    }   
}

/// select a row of data from listtable
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCICUCLCUDisease');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    objtbl.selectrow = selectrow;
    
    //获取行详细信息
    var tRowid=document.getElementById("TRowidz"+selectrow).innerText
    var TCode=document.getElementById("TCodez"+selectrow).innerText;
    var TDesc=document.getElementById("TDescz"+selectrow).innerText;
    var TCtlocDesc=document.getElementById("TCtlocDescz"+selectrow).innerText;
    var TUDSeqNo=document.getElementById("TUDSeqNoz"+selectrow).innerText;
    var TCtlocIdDr=document.getElementById("TCtlocIdDrz"+selectrow).value;
    
    //赋值
    clcUDRowId=tRowid;
    var codeObj=document.getElementById("DisCode");
	if(codeObj) codeObj.value=TCode;
	var descObj=document.getElementById("DisDesc");
	if(descObj) descObj.value=TDesc;
	var ctlocObj=document.getElementById("Ctloc");
	if(ctlocObj){
		ctlocObj.value=TCtlocDesc;
		ctlocObj.idVal=TCtlocIdDr
	}
	var seqNoObj=document.getElementById("SeqNo");
	if(seqNoObj) seqNoObj.value=TUDSeqNo;  
}

//update information to the name of DHC_CLC_UnderlyingDisease table
function UpdateClick(){
	var codeObj=document.getElementById("DisCode");
	if(codeObj) disCode=codeObj.value;
	var descObj=document.getElementById("DisDesc");
	if(descObj) disDesc=descObj.value;
	var ctlocObj=document.getElementById("Ctloc");
	if(ctlocObj) ctlocid=ctlocObj.idVal ? ctlocObj.idVal:"";
	var seqNoObj=document.getElementById("SeqNo");
	if(seqNoObj) seqNo=seqNoObj.value;
	var CLCUDInfo=clcUDRowId+"^"+disCode+"^"+disDesc+"^"+ctlocid+"^"+seqNo;
	var UpdateObj=document.getElementById("UpdateCLCUD");
	if(UpdateObj)
	{
		var UpdateCLCUnderlyingDis=UpdateObj.value;
		var ret=cspRunServerMethod(UpdateCLCUnderlyingDis,CLCUDInfo)
		if(ret!="0")
		{
			alert(ret);
			return;
		}else{alert("修改成功");}
	}
	self.location.reload();
}

function getloc(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("Ctloc")
	if (obj) obj.idVal=loc[0];
	var obj=document.getElementById("ctlocId")
	if (obj) obj.value=loc[0];
	obj=document.getElementById("Ctloc");
	if (obj) obj.value=loc[1];
}

function InsertClick()
{
	//alert(document.getElementById("ctlocId").value)
	var codeObj=document.getElementById("DisCode");
	if(codeObj) disCode=codeObj.value;
	var descObj=document.getElementById("DisDesc");
	if(descObj) disDesc=descObj.value;
	var ctlocObj=document.getElementById("Ctloc");
	if(ctlocObj) ctlocid=ctlocObj.idVal ? ctlocObj.idVal:"";
	var seqNoObj=document.getElementById("SeqNo");
	if(seqNoObj) seqNo=seqNoObj.value;
	var CLCUDInfo=disCode+"^"+disDesc+"^"+ctlocid+"^"+seqNo;
	var InsertObj=document.getElementById("InsertCLCUD");
	if(InsertObj)
	{
		var InsertCLCUnderlyingDis=InsertObj.value;
		var ret=cspRunServerMethod(InsertCLCUnderlyingDis,CLCUDInfo)
		if(ret!="0")
		{
			alert(ret);
			return;
		}else{alert("添加成功");}
	}
	self.location.reload();
}


// delete information
function deleteClick(){
	
	var objtbl=document.getElementById('tDHCICUCLCUDisease');
    
    if(!objtbl.selectrow)
    {
        alert("请选择一行要删除的数据");
        return;
    }
    var deleteobj = document.getElementById("DeteleCLCUD");
    if(deleteobj)
    {
	    var deleteCLCUnderlyingDis=deleteobj.value;
        var result = cspRunServerMethod(deleteCLCUnderlyingDis,clcUDRowId);
        
        if(result != "0")
        {
            alert(result);
            return;
        }else{alert("删除成功");}
        self.location.reload()
	}


}

document.body.onload = BodyLoadHandler;