var SelectedRow=0;
function BodyLoadHandler() {

    var obj=document.getElementById('UpDate');
	if (obj) obj.onclick=UpDate_click;
	var obj=document.getElementById('insert');
	if (obj) {obj.onclick=Add_click;}
	var obj=document.getElementById('Delete');
	if (obj) {obj.onclick=Delete_click};
	var obj=document.getElementById('MUCPLeaderFlag')
	if(obj){obj.onclick=RequiredLeader};
	var obj=document.getElementById('backMedUnit')
	if(obj){obj.onclick=Return_Click};
}



function Delete_click()	{
	if(SelectedRow==0){return;}
	selectrow=SelectedRow
	var SelRowObj=document.getElementById('TMPMUCPRowidz'+selectrow);
	MUCPRowid=SelRowObj.value;
	var Insert=document.getElementById('DeletePerson');
	if (Insert) {var encmeth=Insert.value} else {var encmeth=''};
	var rtn=cspRunServerMethod(encmeth,MUCPRowid);
	if (rtn==0) {
		location.reload();  
	}else if (rtn==105){
		alert("此记录已经使用,不能删除.")
	}else{alert("不可删除?")

	
	}

}
function SelectRowHandler()	{

	obj=document.getElementById('insert')
	if(obj){obj.disabled=true;} 
	tempobj=document.getElementById('UpDate');
	if(tempobj){tempobj.disabled=false;}    
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCCTLocMedUnitCareProv');
	var rows=objtbl.rows.length;                               
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);                                  
	var selectrow=rowObj.rowIndex;                             
	if (!selectrow) return; 
	var myidobj=document.getElementById('myid')
	if (myidobj){}
	var imgname="ld"+myidobj.value+"i"+"CTPCPDescNew"
	var imgobj=document.getElementById(imgname);                                
	if (selectrow!=SelectedRow){                             
		var obj=document.getElementById('CTPCPDescNew');
		if (obj){
			var SelRowObj=document.getElementById('TCTPCPDescNewz'+selectrow);
			obj.value=SelRowObj.innerText;
			obj.disabled=true
		}
		var obj=document.getElementById('CTPCPCode');
		if (obj){
			var SelRowObj=document.getElementById('TCTPCPCodez'+selectrow);
			obj.value=SelRowObj.innerText;
			obj.disabled=true
		}
		var obj=document.getElementById('MUCPLeaderFlag');
		if (obj){
			var SelRowObj=document.getElementById('TMUCPLeaderz'+selectrow);
			if(SelRowObj.value=="Y"){obj.checked=true}
			if(SelRowObj.value!="Y"){obj.checked=false}
		}
		var obj=document.getElementById('MUCPOPFlag');
		if (obj){
			var SelRowObj=document.getElementById('TMUCPOPz'+selectrow);
			if(SelRowObj.value=="N"){obj.checked=false}
			if(SelRowObj.value!="N"){obj.checked=true}			
		}

		var obj=document.getElementById('MUCPIPFlag');
		if (obj){
			var SelRowObj=document.getElementById('TMUCPIPz'+selectrow);
			if(SelRowObj.value=="N"){obj.checked=false}		
			if(SelRowObj.value!="N"){obj.checked=true}
			}
		var obj=document.getElementById('MUCPDateFrom');
		if (obj){
			var SelRowObj=document.getElementById('TMUCPDateFromz'+selectrow);
			obj.value=SelRowObj.innerText;
		}
		var obj=document.getElementById('MUCPDateTo');
		if (obj){
			var SelRowObj=document.getElementById('TMUCPDateToz'+selectrow);
			obj.value=SelRowObj.innerText;	
		}
		var obj=document.getElementById('MUCPRowid');
		if (obj){
			var SelRowObj=document.getElementById('TMUCPRowidz'+selectrow);
			obj.value=SelRowObj.innerText;	
		}

		SelectedRow=selectrow;
		imgobj.style.display="none"  
	}
	else {
		///重复选择某行?我们认为是取消选择?把内容清空
		SelectedRow=0;
		ClearMedUnit();
		imgobj.style.display=""
	}
	
}
function ClearMedUnit()
{	
	var obj=document.getElementById('CTPCPDescNew');
	if(obj){obj.value="";}
	var obj=document.getElementById('CTPCPCode');
	if(obj){obj.value="";}
	var obj=document.getElementById('RESCTPCPDR');
	if(obj){obj.value="";}
	var obj=document.getElementById('MUCPLeaderFlag');
	if(obj){obj.value="";}
	var obj=document.getElementById('MUCPDateFrom');
	if(obj){obj.value="";}
	var obj=document.getElementById('MUCPDateTo');
	if(obj){obj.value="";}
	var obj=document.getElementById('MUCPOPFlag');
	if(obj){obj.value="";}
    var obj=document.getElementById('MUCPIPFlag');
	if(obj){obj.value="";}	
	tempobj=document.getElementById('insert');
	if(tempobj){tempobj.disabled=false;}
	obj=document.getElementById('UpDate')
	if(obj){obj.disabled=true;}
}	
function Add_click()
{
	var CTPCPDescNew=document.getElementById('CTPCPDescNew').value;
	CTPCPDescNew=cTrim(CTPCPDescNew,0)
	if(CTPCPDescNew=="") {
		alert(t['01']);
		return;
		 }
	var CTPCPCode=document.getElementById('CTPCPCode').value;
	CTPCPCode=cTrim(CTPCPCode,0)
	if(CTPCPCode==""){
		alert(t['02']);
		return;
		}
	
	var MUCPLeaderFlag
	var obj=document.getElementById('MUCPLeaderFlag');
	if(obj){
		   if(obj.checked==true){MUCPLeaderFlag="Y"}
			else {MUCPLeaderFlag="N"}
	    	}

	var MUCPDateFrom=""
	var obj=document.getElementById('MUCPDateFrom');
	if(obj){
		MUCPDateFrom=obj.value;
		MUCPDateFrom=limDate(MUCPDateFrom)
	 }
	if(MUCPDateFrom==""){
		alert(t['04']);
		return;
			}
	var MUCPDateTo=document.getElementById('MUCPDateTo').value;
	MUCPDateTo=cTrim(MUCPDateTo,0)
	var MUCPOPFlag
	var obj=document.getElementById('MUCPOPFlag')
	if (obj){
		if(obj.checked==true){MUCPOPFlag="Y"}
		else {MUCPOPFlag="N"}
		
		}
		
	var MUCPIPFlag
	var obj=document.getElementById('MUCPIPFlag');
	if(obj){
		if(obj.checked==true){MUCPIPFlag="Y"}
		else{MUCPIPFlag="N"}
		}
	var MURowid=document.getElementById('MURowid').value
	var RESCTPCPDR=document.getElementById('RESCTPCPDR').value;
	RESCTPCPDR=cTrim(RESCTPCPDR,0)
	if (RESCTPCPDR==""){alert("请通过选择确定医生");return}
	var CompDateFlag=CompareDate(MUCPDateFrom,MUCPDateTo)
	if (!CompDateFlag){alert("请选择有效的日期");return;}
	var Checkeddate=document.getElementById('CheckedDate');          
	if (Checkeddate) {var encmeth=Checkeddate.value} else {var encmeth=''};
	
	var InString=cspRunServerMethod(encmeth,RESCTPCPDR,MUCPDateFrom,MUCPDateTo)
	var InStringArry=InString.split("^")
	if(InStringArry[0]==0){
		alert(t['06']+","+InStringArry[1])
		return;
	}
    else {
	    var MUCPDateFrom=MUCPDateFrom
    	var MUCPDateTo=MUCPDateTo
	}
	if ((MUCPOPFlag=="N")&&(MUCPIPFlag=="N")){
		var Rtn=confirm("没有选择出诊标志是否增加?")
		if (!Rtn){return;}
	}
	
	var InString=RESCTPCPDR+"^"+MUCPLeaderFlag+"^"+MUCPDateFrom+"^"+MUCPDateTo+"^"+MUCPOPFlag+"^"+MUCPIPFlag+"^"+MURowid;

	var Insert=document.getElementById('ADD');
	if (Insert) {var encmeth=Insert.value} else {var encmeth=''};

	if (cspRunServerMethod(encmeth,InString)) {
		location.reload();                ///从新加载页面
	}
	else{
		alert("添加失败")
	}
}


function SetNo(value)     ///放大镜得到的三个输出
{   
    var str=value
    var str1=str.split("^")
    ///CTPCPDescNew^CTPCPCode^CTMUDesc^RESCTPCPDR^MUCPRowid
	var obj=document.getElementById('CTPCPDescNew');
	if(obj){obj.value=str1[0];}

	var obj=document.getElementById('CTPCPCode');
	if(obj){obj.value=str1[1];}

	var obj=document.getElementById('RESCTPCPDR');
	if(obj){obj.value=str1[3];}

	var obj=document.getElementById('MUCPRowid');
	if(obj){obj.value=str1[4];}
		var MUCPRowid=document.getElementById('MUCPRowid').value;
	/*if(MUCPRowid!=""){
		  if (!confirm("已分配医疗单元是否继续")){
			  ClearMedUnit();
			  return;
		  }
		  else{
          var Insert=document.getElementById('DeletePerson');
          if (Insert) {var encmeth=Insert.value} else {var encmeth=''};
          if (cspRunServerMethod(encmeth,MUCPRowid)==0){
	          location.reload();}
          */      

}	

	var obj=document.getElementById("UpDate");
	if (obj){
			obj.disabled=true;
	}


function cTrim(sInputString,iType)
{
  var sTmpStr = ' '
  var i = -1

  if(iType == 0 || iType == 1)
  {
     while(sTmpStr == ' ')
     {
       ++i
       sTmpStr = sInputString.substr(i,1)
     }
     sInputString = sInputString.substring(i)
  }
  return sInputString
}
function UpDate_click()
{	
	if(SelectedRow==0){return;}
	selectrow=SelectedRow
	
	var obj=document.getElementById('CTPCPDescNew')
    if(obj){
	    CTPCPDescNew=obj.value
    	if(CTPCPDescNew==""){
			alert(t['01'])
			return;}
		else{var SelRowObj=document.getElementById('TCTPCPDescNewz'+selectrow);
			 obj.value=SelRowObj.innerText;	}
	    }
	
	var MUCPRowid=document.getElementById('TMPMUCPRowidz'+selectrow).value;
	var obj=document.getElementById('CTPCPDescNew')
	if(obj){CTPCPDescNew=obj.value
			if(CTPCPDescNew==""){
				alert(t['02'])
				return;}
			else{var SelRowObj=document.getElementById('TCTPCPCodez'+selectrow)
			     obj.value=SelRowObj.innerText;}
		     }
	var obj=document.getElementById('MUCPLeaderFlag');
	if(obj){
		if(obj.checked==true){MUCPLeaderFlag="Y"}
		else {MUCPLeaderFlag="N"}
		}
	var MUCPOPFlag
	var obj=document.getElementById('MUCPOPFlag')
	if (obj){
		if(obj.checked==true){MUCPOPFlag="Y"}
		else {MUCPOPFlag="N"}
		}
	var MUCPIPFlag
	var obj=document.getElementById('MUCPIPFlag');
	if(obj){
		if(obj.checked==true){MUCPIPFlag="Y"}
		else{MUCPIPFlag="N"}
		}
	var MUCPDateFrom="";
	var obj=document.getElementById('MUCPDateFrom');
	if(obj){
		MUCPDateFrom=obj.value;
		MUCPDateFrom=limDate(MUCPDateFrom)
	}
	if(MUCPDateFrom==""){
			alert(t['04']);
			return;
	}
	var MUCPDateTo=document.getElementById('MUCPDateTo').value;
	MUCPDateTo=cTrim(MUCPDateTo,0)
	
	var CompDateFlag=CompareDate(MUCPDateFrom,MUCPDateTo)
	if (!CompDateFlag){alert("请选择有效的日期");return;}
	
	var RESCTPCPDR=document.getElementById('TMUCPDoctorDRz'+selectrow).value;	
	var Checkeddate=document.getElementById('CheckedDate');          
	if (Checkeddate) {var encmeth=Checkeddate.value} else {var encmeth=''};
	var InString=cspRunServerMethod(encmeth,RESCTPCPDR,MUCPDateFrom,MUCPDateTo,MUCPRowid)
	var InStringArry=InString.split("^")
	if(InStringArry[0]==0){
		alert(t['06']+","+InStringArry[1])
		return;
	}
	if (RESCTPCPDR==""){alert("请通过选择确定医生");return}
	var instring=MUCPRowid+"^"+MUCPLeaderFlag+"^"+MUCPOPFlag+"^"+MUCPIPFlag+"^"+MUCPDateFrom+"^"+MUCPDateTo+"^"+RESCTPCPDR
	var UpDatePeason=document.getElementById('UpDatePeason');
	if (UpDatePeason) {var encmeth=UpDatePeason.value} else {var encmeth=''};

	if (cspRunServerMethod(encmeth,instring)) {
		location.reload();                ///从新加载页面
	}
	else{
		alert("更新失败")
	}
}
function RequiredLeader()
{	
		var MURowid=document.getElementById('MURowid').value
		if(SelectedRow!=0){
			var MURowid=document.getElementById('TMPMUCPRowidz'+SelectedRow).value;
		}
		var Insert=document.getElementById('RequiredMUCPLeader');
		if (Insert) {var encmeth=Insert.value} else {var encmeth=''};
		var OutStr=cspRunServerMethod(encmeth,MURowid)
		if (OutStr==1){
			alert("此科室已分配组长");
			var obj=document.getElementById('MUCPLeaderFlag')
			obj.checked=false;
			return;
		}	
}
function Return_Click()
{
	var MURowid=document.getElementById('MURowid').value;
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCCTLocMedUnit&tmpRowid='+MURowid;
    //window.open(str,'_blank','fullscreen=3,toolbar=Yes,location=no,directories=no,status=yes,menubar=yes,scrollbars=yes,resizable=yes,copyhistory=Yes,width=900,height=650,left=0,top=0')
	//window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=700,height=500,left=100,top=60')
	location.href=str
}

function limDate(DateInput)
{
	var limDateFrom=document.getElementById('limDateFrom');
	if (limDateFrom) {var encmeth=limDateFrom.value} else {var encmeth=''};
	if (encmeth!=""){DateInput=cspRunServerMethod(encmeth,DateInput)}
	DateInput=cTrim(DateInput,0)
	return DateInput	
}

document.body.onload = BodyLoadHandler;