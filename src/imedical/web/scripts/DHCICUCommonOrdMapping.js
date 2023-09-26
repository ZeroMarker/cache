var SelectedRow = 0,preRowInd=0;
var ancvcCodeold=0;
var selRow=null;
var selectRow=0;
var preSelectRow=-1;
var tbName="tDHCICUCommonOrdMapping";
function BodyLoadHandler(){
	var obj=document.getElementById('ADD')
	if(obj) obj.onclick=ADD_click;
	var obj=document.getElementById('Delete')
	if(obj) obj.onclick=Delete_click;
	var obj=document.getElementById('Update')
	if(obj) obj.onclick=Update_click;
	var obj=document.getElementById('ArcimDescT');
    if (obj){obj.onkeydown=Lookarcim;}
    var obj=document.getElementById('ViewSuperCatDesc');
    if (obj){obj.onkeydown=LookViewSuperCat;}
    var obj=document.getElementById('ViewCatDescT');
    if (obj){obj.onkeydown=LookViewCat;}
    var obj=document.getElementById('ViewCat');
    if (obj){obj.onkeydown=LookViewCat;}
    var obj=document.getElementById('AncoDesc');
    if (obj){obj.onkeydown=LookViewanco;}
    var obj=document.getElementById('SpeedUnitDesc');
    if (obj){obj.onkeydown=LookViewspeedUnit;}
    var obj=document.getElementById('UomDesc');
    if (obj){obj.onkeydown=LookViewuom;}
    
    SetFilter(tbName,"Abbreviate","tAbbreviate");
    SetFilter(tbName,"AncoDesc","tAncoDesc");
    SetFilter(tbName,"ArcimDescT","tArcimDescT");
    SetFilter(tbName,"DefSpeed","tDefSpeed");
    SetFilter(tbName,"Density","tDensity");
    SetFilter(tbName,"Density","tDensity");
    SetFilter(tbName,"PrepareVolume","tPrepareVolume");
    SetFilter(tbName,"Qty","tQty");
	SetFilter(tbName,"SpeedUnitDesc","tSpeedUnitDesc");
	SetFilter(tbName,"UomDesc","tUomDesc");
    SetFilter(tbName,"ViewCatDescT","tViewCatDescT");
    SetFilter(tbName,"Density","tDensity");
    SetFilter(tbName,"ViewSuperCatDesc","tViewSuperCatDesc");
	SetFilter(tbName,"OeoriNoteT","tOeoriNoteT");
	//SetFilter(tbName,"DeptDesc","tDeptDesc");
	InitSortTb(tbName)
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCICUCommonOrdMapping');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	var obj=document.getElementById('anco');	
	var obj1=document.getElementById('speedUnit');
    var obj2=document.getElementById('arcim');
	var obj3=document.getElementById('oeoriNoteT');
	var obj4=document.getElementById('uom');
	var obj5=document.getElementById('density');
	var obj6=document.getElementById('qty');
	var obj7=document.getElementById('prepareVolume');
	var obj8=document.getElementById('abbreviate');
	var obj9=document.getElementById('defSpeed');
	var obj10=document.getElementById('ViewSuperCat');
    var obj11=document.getElementById('ViewCat');
    var obj12=document.getElementById('ViewSuperCatID');
    var obj13=document.getElementById('ViewCatID');
    var obj14=document.getElementById('arcimIDT');
    var obj15=document.getElementById('ancoID');
    var obj16=document.getElementById('speedUnitID');
    var obj17=document.getElementById('uomID');
    
	var SelRowObj=document.getElementById('tancoIdz'+selectrow);	
	var SelRowObj1=document.getElementById('tspeedUnitIdz'+selectrow);
	var SelRowObj2=document.getElementById('tuomIdz'+selectrow);
	var SelRowObj3=document.getElementById('tdensityz'+selectrow);
	var SelRowObj4=document.getElementById('tqtyz'+selectrow);
	var SelRowObj5=document.getElementById('tprepareVolumez'+selectrow);	
	var SelRowObj6=document.getElementById('tabbreviatez'+selectrow);
	var SelRowObj7=document.getElementById('tdefSpeedz'+selectrow);
	var SelRowObj8=document.getElementById('tViewSuperCatIDTz'+selectrow);	
    var SelRowObj9=document.getElementById('tViewCatIDTz'+selectrow);   
    var SelRowObj10=document.getElementById('tarcimIDTz'+selectrow);
    var SelRowObj11=document.getElementById('toeoriNoteTTz'+selectrow);
    var SelRowObj12=document.getElementById('tViewSuperCatDescTz'+selectrow);
    var SelRowObj13=document.getElementById('tViewCatDescTz'+selectrow);
    var SelRowObj14=document.getElementById('tarcimDescTz'+selectrow);
    var SelRowObj15=document.getElementById('tancoDescz'+selectrow);
    var SelRowObj16=document.getElementById('tspeedUnitDescz'+selectrow);
    var SelRowObj17=document.getElementById('tuomDescz'+selectrow);
     
    if (preRowInd==selectrow){
	   obj.value=""; 
       obj1.value="";
       obj2.value="";
       obj3.value="";
       obj4.value="";
       obj5.value="";
       obj6.value="";
       obj7.value="";
       obj8.value="";
       obj9.value="";
       obj10.value="";
	   obj11.value="";
	   obj12.value="";
	   obj13.value="";
	   obj14.value="";
	   obj15.value="";
	   obj16.value="";
	   obj17.value="";
   	   preRowInd=0;
    }
   else{
	    obj.value=SelRowObj15.innerText;
		obj1.value=SelRowObj16.value;
		obj2.value=SelRowObj14.innerText;
		obj3.value=SelRowObj11.innerText;	
	    obj4.value=SelRowObj17.innerText;
		obj5.value=SelRowObj3.innerText;
		obj6.value=SelRowObj4.innerText;
		obj7.value=SelRowObj5.innerText;
		obj8.value=SelRowObj6.innerText;
		obj9.value=SelRowObj7.innerText;	
		
		obj10.value=SelRowObj12.innerText;
		obj11.value=SelRowObj13.innerText;
		obj12.value=SelRowObj8.innerText;
		obj13.value=SelRowObj9.innerText;
		obj14.value=SelRowObj10.innerText;
	    obj15.value=SelRowObj.innerText;
	    obj16.value=SelRowObj1.innerText;
	    obj17.value=SelRowObj2.innerText;	    
	
	    if(obj.value==" "){
		   obj.value="" 
	    }
	    if(obj1.value==" "){
		   obj1.value="" 
	    }
	    if(obj2.value==" "){
		   obj2.value="" 
	    }
	    if(obj3.value==" "){
		   obj3.value="" 
	    }
	    if(obj4.value==" "){
		   obj4.value="" 
	    }
	    if(obj5.value==" "){
		   obj5.value="" 
	    }
	    if(obj6.value==" "){
		   obj6.value="" 
	    }
	    if(obj7.value==" "){
		   obj7.value="" 
	    }
	    if(obj8.value==" "){
		   obj8.value="" 
	    }
	    if(obj9.value==" "){
		   obj9.value="" 
	    }
	    if(obj10.value==" "){
		   obj10.value="" 
	    }
	    if(obj11.value==" "){
		   obj11.value="" 
	    }
	    if(obj12.value==" "){
		   obj12.value="" 
	    }
	    if(obj13.value==" "){
		   obj13.value="" 
	    }
	    if(obj14.value==" "){
		   obj14.value="" 
	    }
	    if(obj15.value==" "){
		   obj15.value="" 
	    }
	    if(obj16.value==" "){
		   obj16.value="" 
	    }
	    if(obj17.value==" "){
		   obj17.value="" 
	    }    	    
	    //SelectedSet(obj10,SelRowObj8.innerText,"|");
	    //SelectedSet(obj11,SelRowObj9.innerText,"|");	    
		preRowInd=selectrow;
   }   	
	SelectedRow=selectrow;
	return;
	}
function ADD_click(){
	var ViewSuperCat,ViewSuperCatId,ViewCat,ViewCatId,arcim,speedUnitID,speedUnit,ancoID,anco,oeoriNoteT,uomID,uom,density,qty,prepareVolume,abbreviate,defSpeed="";
	var IcuApply,ancvcAnApply="",ancvcIcuApply="";
	    
    var typeobj=document.getElementById('ViewSuperCatID');
	 var obj=document.getElementById('ViewSuperCat');
	 if(typeobj)  ViewSuperCat=typeobj.value;
	 if(ViewSuperCat==""){
		alert("医嘱大类不能为空") 
		return;
		}
		    
    var typeobj=document.getElementById('ViewCatID');
	 var obj=document.getElementById('ViewCat');
	 //var ViewCat=selitem(obj,'|');
	//if(obj)  ViewCat=obj.value
	if(typeobj)  ViewCat=typeobj.value;   
	
	var obj=document.getElementById('ArcimIDT')
	if(obj)  arcim=obj.value;	
	var obj=document.getElementById('SpeedUnitID')
	if(obj)  speedUnit=obj.value;	
    var obj=document.getElementById('AncoID')
	if(obj)  anco=obj.value;
	if((anco=="")&&((ViewSuperCat!=""))){
		alert("常用医嘱不能为空")
		return;
		}	
	var obj=document.getElementById('OeoriNoteT')
	if(obj)  oeoriNoteT=obj.value;	
	var obj=document.getElementById('UomID')
	if(obj)  uom=obj.value;	
	var obj=document.getElementById('Density')
	if(obj)  density=obj.value;	
	var obj=document.getElementById('Qty')
	if(obj)  qty=obj.value;	
	var obj=document.getElementById('PrepareVolume')
	if(obj)  prepareVolume=obj.value;
	var obj=document.getElementById('Abbreviate')
	if(obj)  abbreviate=obj.value;
	var obj=document.getElementById('DefSpeed')
	if(obj)  defSpeed=obj.value;

	var obj9=document.getElementById('IcuApply');
	if (obj9)
	{	
	    obj9.value="Y"
	}
	var obj10=document.getElementById('DeptId');
	if (obj10)
	{
		deptId=obj10.value;
	}
	var obj10=document.getElementById('DeptDesc');
	var deptIds="";
	if (obj10)
	{
		deptIds = selitem(obj10,";");
	}
	var obj=document.getElementById('InsertOrdMapping')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,ViewSuperCat,ViewCat,arcim,speedUnit,anco,oeoriNoteT,uom,density,qty,prepareVolume,abbreviate,defSpeed,deptIds)
	    if (resStr!='0'){
			alert("保存出错");
			return;
			}	
		else  {alert("保存成功");
		location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCICUCommonOrdMapping";;
		}
	}
}
function Delete_click(){
	if (preRowInd<1) return;
	var ViewSuperCat,ViewCat,arcim,oeoriNoteT;
		
	var obj=document.getElementById('ViewSuperCatID');
	if(obj)  ViewSuperCat=obj.value;
	var obj=document.getElementById('ViewCatID');
	if(obj)  ViewCat=obj.value;
	var obj=document.getElementById('ArcimIDT')
	if(obj)  arcim=obj.value;
	var obj=document.getElementById('OeoriNoteT')
	if(obj)  oeoriNoteT=obj.value;
	
	//if((ViewSuperCat=="")||(ViewCat=="")||(arcim=="")||(oeoriNoteT=="")){
	//	alert("请重新选中此行后删除"); 
	//	return;
	//	}	
	var obj=document.getElementById('DeleteOrdMapping')
	if(obj) var encmeth=obj.value;
	//alert(ViewSuperCat+"^"+ViewCat+"^"+arcim+"^"+oeoriNoteT);
	var resStr=cspRunServerMethod(encmeth,ViewSuperCat,ViewCat,arcim,oeoriNoteT)
	if (resStr!='0')
		{alert("删除错误");
		return;}	
	else {
	//  alert("删除成功");
	//  location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCICUCommonOrdMapping"; //&IcuApply="+IcuApply;
	$(selRow).remove();
	}
}
function Update_click(){
	var ViewSuperCat,ViewSuperCatID,ViewCat,ViewCatID,arcim,speedUnitID,speedUnit,ancoID,anco,oeoriNoteT,uomID,uom,density,qty,prepareVolume,abbreviate,defSpeed="";
	var IcuApply,ancvcAnApply="",ancvcIcuApply="";
	
	var obj=document.getElementById('ViewSuperCatID');	
	 if(obj)  ViewSuperCat=obj.value;
	 
    var obj=document.getElementById('ViewCatID');
	if(obj)  ViewCat=obj.value; 	
	
	var obj=document.getElementById('ArcimIDT')
	if(obj)  arcim=obj.value;

	var obj=document.getElementById('SpeedUnitID')
	if(obj)  speedUnit=obj.value;

    var obj=document.getElementById('AncoID')
	if(obj)  anco=obj.value;

	var obj=document.getElementById('OeoriNoteT')
	if(obj)  oeoriNoteT=obj.value;

	var obj=document.getElementById('UomID')
	if(obj)  uom=obj.value;

	var obj=document.getElementById('Density')
	if(obj)  density=obj.value;

	var obj=document.getElementById('Qty')
	if(obj)  qty=obj.value;

	var obj=document.getElementById('PrepareVolume')
	if(obj)  prepareVolume=obj.value;

	var obj=document.getElementById('Abbreviate')
	if(obj)  abbreviate=obj.value;

	var obj=document.getElementById('DefSpeed')
	if(obj)  defSpeed=obj.value;

	var obj9=document.getElementById('IcuApply');
	if (obj9)
	{	
	    obj9.value="Y"
	}
	var obj10=document.getElementById('DeptDesc');
	var deptIds="";
	if (obj10)
	{
		deptIds = selitem(obj10,";");
	}
	var obj=document.getElementById('UpdateOrdMapping')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,ViewSuperCat,ViewCat,arcim,speedUnit,anco,oeoriNoteT,uom,density,qty,prepareVolume,abbreviate,defSpeed,deptIds);
	    if (resStr!='0'){
			alert("保存失败"+" "+"Code="+resStr);
			return;
			}	
		else  {
		SaveSelRow(tbName)
		//alert("修改成功");
		//location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCICUCommonOrdMapping; //&IcuApply="+IcuApply;
		}
	}
}
function selitem(selbox,delimStr)
{
      var tmpList=new Array();
        for ( var i=0;i<selbox.options.length;i++)
		{   
			if (selbox.options[i].selected)
			{   //alert(tmpList.length+" //"+tmpList)
			    tmpList[tmpList.length]=selbox.options[i].value
			}
		}
		if (tmpList[0]=="") tmpList=tmpList.slice(1)
		var Str=tmpList.join(delimStr);
  return Str
}
function SelectedSet(selObj,indStr,delim) 
{//查询条件设置
	var tmpList=new Array();
	for(i=0;i<selObj.options.length;i++)
	{
		selObj.options[i].selected=false;
	}
	tmpList=indStr.split(delim)
	for(j=0;j<tmpList.length;j++)
	{
		for(i=0;i<selObj.options.length;i++)
		{
			if (selObj.options[i].value==tmpList[j])
		    {
			    selObj.options[i].selected=true;break
		    }
		}
	}
}
function SetVSC(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("ViewSuperCatDesc");
	Obj.value=obj[0];
	var Obj=document.getElementById("ViewSuperCatID");
	Obj.value=obj[1];	
}
function SetVC(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("ViewCatDescT");
	Obj.value=obj[0];
	var Obj=document.getElementById("ViewCatID");
	Obj.value=obj[1];	
}
function Setarcim(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("arcimDescT");
	Obj.value=obj[0];	
	var Obj=document.getElementById("arcimIDT");
	Obj.value=obj[1];		
}
function Setanco(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("AncoDesc");
	Obj.value=obj[0];
	var Obj=document.getElementById("AncoID");
	Obj.value=obj[1];	
}
function SetspeedUnit(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("SpeedUnitDesc");
	Obj.value=obj[0];
	var Obj=document.getElementById("SpeedUnitId");
	Obj.value=obj[1];	
}
function Setuom(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("UomDesc");
	Obj.value=obj[0];
	var Obj=document.getElementById("UomId");
	Obj.value=obj[1];	
}

function LookViewSuperCat()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	ViewSuperCatDesc_lookuphandler();
	}
}
function LookViewCat()
{
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	ViewCatDescT_lookuphandler();
	}
}

function Lookarcim()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	ArcimDescT_lookuphandler();
	}
}
function LookViewanco()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	AncoDesc_lookuphandler();
	}
}
function LookViewspeedUnit()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	SpeedUnitDesc_lookuphandler();
	}
}
function LookViewuom()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	UomDesc_lookuphandler();
	}
}
function SetFilter(tbName,ctrName,colName){
		tbName="#"+tbName+" > tbody> tr";
		$("#"+ctrName).bind('textchange', function () {
        var fStr = $(this).val();        
        //colName=ctrName+"z";
        $(tbName).each(function () {
	        var cellValue=$("#"+colName+"z"+this.rowIndex).text();
	        fStr=fStr.toUpperCase();
	        fStr.replace(" ","+");
            var strArray = fStr.split('+');
            
            var obj = $(this);

			cellValue=cellValue.toUpperCase();
            var isFind = true;

            for (var i = 0; i < strArray.length; i++) {
                if (cellValue.indexOf(strArray[i]) < 0) {
                    isFind = false;
                    break;
                }
            }
            if (fStr == "") isFind = true;
            if (isFind || obj.hasClass("clsRowSelected")) {
                obj.show();
            }
            else obj.hide();
        });
    });
	}
function InitSortTb(tbName)
{
	tbName="#"+tbName;
	$(tbName+" thead tr th").each(function(){
	    $(this).attr("sort","true");
	    });
    $(tbName).sort({
			'ascImgUrl':'../scripts/dhcclinic/jQuery/images/bullet_arrow_up.png',  //升序图片
			'descImgUrl':'../scripts/dhcclinic/jQuery/images/bullet_arrow_down.png', //降序图片
			'endRow':0		//需要排序的最后一行  -1代表  倒数第二行
		});
	$(tbName+" thead tr th").click(function(){	    	
			$(":checkbox").attr("checked",$(this).attr("checked"));
		});
	$(tbName+" tbody tr").click(function(){
		if(selRow)
		$(selRow).removeClass("clsRowSelected");
		selRow = this;
		preSelectRow = selectRow;
		preRowInd=selectRow = this.rowIndex;
		// $("#tDHCICUCIOItem tbody tr").removeClass("clsRowSelected");
        $(this).toggleClass("clsRowSelected");
        var rowId=$(this).children("td").eq(1).text();
        
        $(this).children("td").each(function(){	
        		if($(this).html()=="")return;
        		if($(this).children("LABEL").length>0){
	        	var id=$(this).children("LABEL")[0].id;
	        	var value = $(this).children("LABEL").eq(0).text();
        		}
	        	else {
		        	var id=$(this).children("input")[0].id;
		        	var value = $(this).children("input").eq(0).val();
	        	}
	        	var lastIndex=id.lastIndexOf('z');
	        	var ctrlName=id.substring(2,lastIndex);
	        	var ch1=id.charAt(1);		    	
		    	if(value == " ")value="";
		    	upperName="#"+ch1.toUpperCase()+ctrlName;
		    	lowerName="#"+ch1.toLowerCase()+ctrlName;
		    	var ctrlName=null;
		    	if($(upperName).length != 0)ctrlName=upperName;
		    	else if($(lowerName).length != 0)ctrlName=lowerName;
		    	if(ctrlName != "")
		    	{ 
			    	 var ctrlType=$(ctrlName).attr("type");
			    	 if(ctrlType == "text" || ctrlType == "hidden") $(upperName).val(value);
			    	 else if(ctrlType == "select-multiple")
			    	 {
				    	// 去除所有选项
				    	$(ctrlName+" option").each(function() {
					    	$(this).attr("selected", false); 
				    	});
						$(ctrlName+" option").each(function() {  
						options = value.split(";");
						for(i=0;i<options.length;i++)
						{
        					if ($(this).text() == options[i]) {  
                			$(this).attr("selected", "selected");  
                			break;  
            			}  
						}
        				});   
			    	 }
		    	}		       
	        });
		});
}
function SaveSelRow(tbName)
{
	 $(selRow).children("td").each(function(){	
        		if($(this).html()=="")return;
        		
		        
        		if($(this).children("LABEL").length>0){
	        	var id=$(this).children("LABEL")[0].id;
	        	var lastIndex=id.lastIndexOf('z');
	        	var ctrlName=id.substring(2,lastIndex);
	        	var ch1=id.charAt(1);		    	
		    	upperName="#"+ch1.toUpperCase()+ctrlName;
		    	lowerName="#"+ch1.toLowerCase()+ctrlName;
		    	if($(upperName).length != 0) value=$(upperName).val();
		    	
		        else if($(lowerName).length != 0) value=$(lowerName).val();
	        	$(this).children("LABEL").eq(0).text(value);
        		}
	        	else {
		        var id=$(this).children("input")[0].id;
		        var lastIndex=id.lastIndexOf('z');
	        	var ctrlName=id.substring(2,lastIndex);
	        	var ch1=id.charAt(1);		    	
		    	upperName="#"+ch1.toUpperCase()+ctrlName;
		    	lowerName="#"+ch1.toLowerCase()+ctrlName;
		    	
		    	if($(upperName).length != 0) value=$(upperName).val();
		        else if($(lowerName).length != 0) value=$(lowerName).val();
		        	$(this).children("input").eq(0).val(value);
	        	}
	        });
}
function SetElementFromListByName(firstElementName,firstType,secondElementName,secondType,value,delimit,firstPos,secondPos)
{
	var valueList=value.split(delimit)
	if ((valueList.length<=firstPos)||(valueList.length<=secondPos)) return  "Index exceed list length!";
	
	SetCtrlVal(firstElementName,valueList[firstPos]);
	SetCtrlVal(secondElementName,valueList[secondPos]);
	//SetElementValue(firstElementName,firstType,valueList[firstPos]);
	//SetElementValue(secondElementName,secondType,valueList[secondPos]);
}
function SetCtrlVal(ctrlName,value)
{
	var ch1=ctrlName.charAt(0);
	upperName="#"+ch1.toUpperCase()+ctrlName.substring(1);
	lowerName="#"+ch1.toLowerCase()+ctrlName.substring(1);
	if($(upperName).length != 0) $(upperName).val(value);
	else if($(lowerName).length != 0)
	$(lowerName).val(value);
}
function GetCtrlVal(ctrlName)
{
	var ch1=ctrlName.charAt(0);
	upperName="#"+ch1.toUpperCase()+ctrlName.substring(1);
	lowerName="#"+ch1.toLowerCase()+ctrlName.substring(1);
	if($(upperName).length != 0) return $(upperName).val();
	else if($(lowerName).length != 0)
	return $(lowerName).val();
}

function LookUpWardLoc(paras)
{
	var deptName=paras.split("^")[7];
	var deptID=paras.split("^")[2];
	var deptNameObj=document.getElementById('DeptDesc');
	var deptIDObj=document.getElementById('DeptID');
	deptNameObj.value=deptName;
	deptIDObj.value=deptID;
}
function selitem(selbox,delimStr)
{
      var tmpList=new Array();
        for ( var i=0;i<selbox.options.length;i++)
		{   
			if (selbox.options[i].selected)
			{   //alert(tmpList.length+" //"+tmpList)
			    tmpList[tmpList.length]=selbox.options[i].value
			}
		}
		if (tmpList[0]=="") tmpList=tmpList.slice(1)
		var Str=tmpList.join(delimStr);
  return Str
}
document.body.onload = BodyLoadHandler;