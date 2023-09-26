var userID=session['LOGON.GROUPID']
var id="",iSeldRow=0,TarId="",InsuId="",InsuCode="",InsuDesc="",INTIMExpiryDate=""

function BodyLoadHandler() {	
	var obj=document.getElementById("Contrast");
	if (obj){ obj.onclick=Updat_click;}
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click;}

	var obj=document.getElementById("UpdateExpiryDate");
	if (obj){ obj.onclick=UpdateExpiryDate_click;}
	
	ini()
	}
function ini() {
	
	
	var obj=document.getElementById("Delete");
	if (obj){ obj.disabled=true;}
	
	var obj=document.getElementById("TarId");
	if (obj) {TarId=obj.value}
	if (TarId=="") {alert("TarId为空！");return;}
	var VerStr=tkMakeServerCall("web.INSUTarContrastListCom","GetTariInfo",TarId);
	var Arr=VerStr.split("^")
	var obj=document.getElementById("HisCode");
	if (obj) {obj.value=Arr[1]}
	var obj=document.getElementById("HisDesc");
	if (obj) {obj.value=Arr[2]}
	var obj=document.getElementById("DW");
	if (obj) {obj.value=Arr[3]}
	var obj=document.getElementById("Cate");
	if (obj) {obj.value=Arr[4]}
	var obj=document.getElementById("SubCate");
	if (obj) {obj.value=Arr[5]}
	var obj=document.getElementById("Price");
	if (obj) {obj.value=Arr[6]}
	
	}	

function Updat_click(){
	var obj
	if (InsuId=="") {alert("请选择医保项目");return;}
    var obj=document.getElementById("HisCode");
	if (obj) {var HisCode=obj.value}
	var obj=document.getElementById("HisDesc");
	if (obj) {var HisDesc=obj.value}
    obj=document.getElementById('iActDate');
    if (obj){
	    if (obj.value==""){var INTCTActiveDate="" }
	    else {var INTCTActiveDate=obj.value.split("/")[2]+"-"+obj.value.split("/")[1]+"-"+obj.value.split("/")[0] }
	    }
    obj=document.getElementById('ExpiryDate');
    if (obj){
	    if (obj.value==""){var INTCTExpiryDate="" }
	    else {var INTCTExpiryDate=obj.value.split("/")[2]+"-"+obj.value.split("/")[1]+"-"+obj.value.split("/")[0] }
	    }
    var obj=document.getElementById("Type");
	if (obj) {var InsuType=obj.value}
	
	//判断医保目录生效失效时间和医保对照生效失效时间
	if ((INTIMExpiryDate!="")&&(INTIMExpiryDate!=" ")){  
		if (INTCTExpiryDate=="")
		{
			alert("医保项目的失效日期是 "+INTIMExpiryDate+" ，请填写在该日期之前的对照失效日期");
			return;
		}
		else
		{
			if (INTCTExpiryDate>INTIMExpiryDate){alert("医保项目的失效日期是 "+INTIMExpiryDate+" ，请填写在该日期之前的对照失效日期");return;}
		}      
	}
	if (confirm("确定将 "+HisCode+"-"+HisDesc+" 对照为 "+InsuDesc+" ?")){
		var Qty="1"
    	var UpdateStr="^"+TarId+"^"+HisCode+"^"+HisDesc+"^"+InsuId+"^"+InsuCode+"^"+InsuDesc+"^"+"^"+"^"+"^"+Qty+"^"+"^"+INTCTActiveDate+"^"+"^"+InsuType+"^"+userID+"^"+"TEST^TEST"+"^"+INTCTExpiryDate+"^"+"^"+"^"+"^"+"^"+"^" 
        alert(UpdateStr)
        var Ins=document.getElementById('ClasstxtUpdate');
        if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
        var flag=cspRunServerMethod(encmeth,'','',UpdateStr)
        alert(flag)
        if (+flag>0) {
	        alert("对照成功！")
	        self.location.reload();
	        }
        else{alert("对照失败，ErrNo="+flag)}
		}
	}
function Delete_click(){	

	var obj=document.getElementById("Delete");
	if (obj){ if(obj.disabled==true){return;}}
	
	if (id==""){alert("请选择一条对照数据！");return false}		
    if (confirm("确定要删除选定的对照关系吗?")){
		var Ins=document.getElementById('ClasstxtDelete');
        if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
        var flag=cspRunServerMethod(encmeth,'','',id)
        if (flag=='0') {
	        alert("删除成功！")
	        self.location.reload()
	        }
        else{alert("删除失败，ErrNo="+flag)}
		}
	}

function UpdateExpiryDate_click() {
	var ExpiryDate=""
	var obj=document.getElementById("ExpiryDate");
	if (obj) { 
		if (obj.value==""){ExpiryDate=""}
		else {ExpiryDate=obj.value.split("/")[2]+"-"+obj.value.split("/")[1]+"-"+obj.value.split("/")[0]}
		}
	if (id==""){alert("请选择一条对照数据！");return;}	
	if (ExpiryDate=="") {var TmpExpiryDate="空"}
	else {var TmpExpiryDate=ExpiryDate}
	if (confirm("要把照失效日期改成 "+TmpExpiryDate+" 吗 ?")){
			var VerStr=tkMakeServerCall("web.INSUTarContrastListCom","UpdateExpiryDate",id,ExpiryDate);
			if (+VerStr<0) {alert("修改失效日期失败，SQLCODE="+VerStr)}
			else {alert("修改失效日期成功！");self.location.reload()}
		}
	}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tINSUTarContrastListCom');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;	
	
	if (!selectrow) return;
	if (iSeldRow==selectrow){
		iSeldRow=0
		id=""
		return;
		}
	iSeldRow=selectrow;
	var SelRowObj
	var obj
	SelRowObj=document.getElementById('ConIdz'+selectrow);	
	if (SelRowObj){id=SelRowObj.value;}
	else{id=""}
}

function SetInsuString(value) {
	var Arr=value.split("^")
	InsuId=Arr[1]
	InsuCode=Arr[4]
	var obj=document.getElementById("InsuQuery");
	if (obj) {obj.value=Arr[5]}
	InsuDesc=Arr[5]
	INTIMExpiryDate=Arr[47]
	
	}


	
document.body.onload = BodyLoadHandler;
