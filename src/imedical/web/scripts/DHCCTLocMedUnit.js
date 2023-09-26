var SelectedRow = 0;
var Code;
var Desc;
function BodyLoadHandler() {
    var obj=document.getElementById('addd');
	if (obj) obj.onclick=Addclick;
	var obj=document.getElementById('New');
	if (obj){obj.onclick=UpDateclick;}
	var obj=document.getElementById('Delele');
	if (obj) {obj.onclick=Deleteclick;}
	var obj=document.getElementById('CTDesc');
	if (obj) {obj.onkeyup=CTDesc_onkeyup;}
	ini();
	line_red();
}
	
function Addclick()	
{
	var Code=document.getElementById('Code').value;
	Code=cTrim(Code,0)
	if (Code=="") {
		alert(t['01'])
		return;
	}
	
	var Desc=document.getElementById('Desc').value;
    Desc=cTrim(Desc,0)
    if (Desc=="") {
		alert(t['02']);
		return;}
    
    var ActiveFlag=document.getElementById('ActiveFlag').value;
 	ActiveFlag=cTrim(ActiveFlag,0)
    if (ActiveFlag=="")
    {
	    alert(t['03']);
	    return;
    }
    
    var DateFrom=document.getElementById('DateFrom').value;
    DateFrom=cTrim(DateFrom,0)
    if (DateFrom=="") 
    {
		alert(t['04']);
		return;
	}

	var DateTo=document.getElementById('DateTo').value;
    DateTo=cTrim(DateTo,0)
    var DateFlag=CompareDate(DateFrom,DateTo)
    if (!DateFlag){alert("请选择有效的日期");return}
	
	var CTLocDr=document.getElementById('CTLocDr').value;	
	
	CTLocDr=cTrim(CTLocDr,0)
	if(CTLocDr=="")
	{
		alert(t['07']);
		return;
	}
    
    var InString=Code+"^"+Desc+"^"+ActiveFlag+"^"+DateFrom+"^"+DateTo+"^"+CTLocDr;
	
	var Insert=document.getElementById('Insert');
	if (Insert) {var encmeth=Insert.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,InString)) {
		location.reload();                ///从新加载页面
	}
	else{
		alert("添加失败")
	}

}



function UpDateclick()	
{
	var Code=document.getElementById('Code').value;
	Code=cTrim(Code,0)
	if (Code=="") {
		alert(t['01'])
		return;
	}

	var Desc=document.getElementById('Desc').value;
    Desc=cTrim(Desc,0)
    if (Desc=="") {
		alert(t['02']);
		return;}
    
    var ActiveFlag=document.getElementById('ActiveFlag').value;
 	ActiveFlag=cTrim(ActiveFlag,0)
    if (ActiveFlag=="")
    {
	    alert(t['03']);
	    return;
    }
    
    var DateFrom=document.getElementById('DateFrom').value;
    DateFrom=cTrim(DateFrom,0)
    if (DateFrom=="") 
    {
		alert(t['04']);
		return;
	}
	var DateTo=document.getElementById('DateTo').value;
    DateTo=cTrim(DateTo,0)
    if ((DateTo=="")||(DateTo==" ")) {}
	var MURowid=document.getElementById('MURowid').value;	

	MURowid=cTrim(MURowid,0)
	if(MURowid=="")
	{
		return;
	}
	var DateFlag=CompareDate(DateFrom,DateTo)
    if (!DateFlag){alert("请选择有效的日期");return}

    var InString=Code+"^"+Desc+"^"+ActiveFlag+"^"+DateFrom+"^"+DateTo+"^"+MURowid;

	var Ins=document.getElementById('ins');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,InString)=="0") {
		location.reload();                ///从新加载页面
	}
	else{
		alert("更新失败")
	}

}

function SetLoc(value)     
{   
    var str=value
    var str1=str.split("^")
	var obj=document.getElementById('CTDesc');
	obj.value=str1[0];
	var obj=document.getElementById('CTLocDr');
	obj.value=str1[2];

}	
function SelectRowHandler()	{   
    tempobj=document.getElementById('addd');
    if(tempobj){
	   tempobj.disabled=true;
	    }
	var eSrc=window.event.srcElement;
	///tCTLocMedUnite 表示组件CTLocMedUnite中的table
	var objtbl=document.getElementById('tDHCCTLocMedUnit');
	///得到表格的总行数
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	///把表格中被选中的那一行赋值到rowObj中
	var rowObj=getRow(eSrc);
	///得到选中行的序号selectrow它是一个全局变量
	var selectrow=rowObj.rowIndex;
	///如果没有选中任何行,"更新"按钮变灰如果选择某一行¨更新〃按钮可用
	if (!selectrow)return;
	else{
		tempobj=document.getElementById('New')
		tempobj.disabled=false;
		}
	
	///如果重新选中的行与原选中行不同则更改
	if (selectrow!=SelectedRow){
		
		var obj=document.getElementById('CTDesc');
		if (obj){
			var SelRowObj=document.getElementById('TCTCodez'+selectrow);
			obj.value=SelRowObj.innerText;	
		}
		var obj=document.getElementById('CTLocDr');
		if (obj){
			var SelRowObj=document.getElementById('TCTLocDrz'+selectrow);
			obj.value=SelRowObj.value;	///隐藏元素用value
		}
		var obj=document.getElementById('CTChildsub');
		if (obj){
			var SelRowObj=document.getElementById('TCTChildsubz'+selectrow);
			obj.value=SelRowObj.value;	///隐藏元素用value
			//alert(SelRowObj.value)
		}
		
		
		//DHCC_SetElementData('Code',DHCC_GetColumnData('TCTMUCode',selectrow));
		
		var obj=document.getElementById('Code');
		if (obj){
			//DHCC_GSetColumnData('TCTMUCode',selectrow)
			var SelRowObj=document.getElementById('TCTMUCodez'+selectrow);
			obj.value=SelRowObj.innerText;                     ///SelRowObj是选中行的'TCTMUCode'这个元素
		}
		var obj=document.getElementById('Desc');
		if (obj){
			var SelRowObj=document.getElementById('TCTMUDescz'+selectrow);
			obj.value=SelRowObj.innerText;
		}
		var obj=document.getElementById('ActiveFlag');
		if (obj){
			var SelRowObj=document.getElementById('TActiveFlagz'+selectrow);
			//alert("SelRowObj.innerText="+SelRowObj.value)
			obj.value=SelRowObj.value;
		}
		var obj=document.getElementById('DateFrom');
		if (obj){
			var SelRowObj=document.getElementById('TDateFromz'+selectrow);
			obj.value=SelRowObj.innerText;
		}
		var obj=document.getElementById('DateTo');
		if (obj){
			var SelRowObj=document.getElementById('TDateToz'+selectrow);
			obj.value=SelRowObj.innerText;
		}
		var obj=document.getElementById('MURowid');
		
		if (obj){
			var SelRowObj=document.getElementById('TMURowidz'+selectrow);
			obj.value=SelRowObj.value;}
			for (i=1;i<objtbl.rows.length;i++){
				objtbl.rows[SelectedRow].style.color="black"
				}	
				SelectedRow=selectrow;			
				var objtbl=document.getElementById('tDHCCTLocMedUnit');
				if (objtbl)
				{
				for (i=1;i<objtbl.rows.length;i++)
					{
				
					if(SelectedRow!=""){objtbl.rows[SelectedRow].style.color="red"}
					else if(SelectedRow==0){rowObj.style.color="black"}
					}
				}
	}
	else {
		///重复选择某行我们认为是取消选择把内容清空
		SelectedRow=0;
		ClearMedUnit();
	}
	
}
	///清空医疗单元的所对应的内容
function ClearMedUnit()
{	
	var obj=document.getElementById('Code');
	if(obj){obj.value="";}
	var obj=document.getElementById('Desc');
	if(obj){obj.value="";}
	var obj=document.getElementById('ActiveFlag');
	if(obj){obj.value="";}
	var obj=document.getElementById('DateFrom');
	if(obj){obj.value="";}
	var obj=document.getElementById('DateTo');
	if(obj){obj.value="";}
	tempobj=document.getElementById('addd');
	if(tempobj){tempobj.disabled=false;}
	obj=document.getElementById('New')
	if(obj){obj.disabled=true;}	
}


function ini(){

	var obj=document.getElementById("ActiveFlag");
	if (obj){
		obj.size=1; ///就是说listbox只显示1行
		obj.multiple=false;
		obj.options[0]=new Option("激活","Y");///显示的是激活 但它的值是¨YES〃
		obj.options[1]=new Option("未激活","N");///这句话是往listbox中添加值
	}
	var obj=document.getElementById("New");
	if (obj){
			obj.disabled=true;
	}

}
function Deleteclick(){
	var selectrow=SelectedRow;
    if(selectrow==0) return;
	var MURowid=document.getElementById('TMURowidz'+selectrow);
	MURowid=cTrim(MURowid.value,0);	///隐藏元素用value
  	var Del=document.getElementById('Dle');
	if (Del) {var encmeth=Del.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,MURowid)=="N") {
		
		location.reload();
	}
	else{
		alert("删除失败")	
	}
}

//****************************************************************
// Description: sInputString 为输入字符串?iType为类型?分别为
// 0 - 去除前后空格; 1 - 去前导空格; 2 - 去尾部空格
//****************************************************************
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

  if(iType == 0 || iType == 2)
  {
    sTmpStr = ' '
    i = sInputString.length
    while(sTmpStr == ' ')
    {
       --i
       sTmpStr = sInputString.substr(i,1)
    }
    sInputString = sInputString.substring(0,i+1)
  }
  return sInputString
}
function line_red()
{
	var objtbl=document.getElementById('tDHCCTLocMedUnit');
	var obj=document.getElementById('tmpRowid')
	if (objtbl)
	{
		for (i=1;i<objtbl.rows.length;i++)
		{
			var objTMURowid=document.getElementById('TMURowidz'+i);
			if(objTMURowid.value==obj.value){objtbl.rows[i].style.color="red"}
		}
	}
		obj.value=""
}
function CTDesc_onkeyup()
{
	var obj=document.getElementById('CTDesc');
	if (obj.value==""){
		var obj=document.getElementById('CTLocDr');
		if (obj){obj.value=""}
	}

}

document.body.onload = BodyLoadHandler;


