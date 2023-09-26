var preSelectRow=-1;
var selectRow=0;
var selRow=null;
function BodyLoadHandler()
{
	var obj=document.getElementById('Insert')
	if(obj) obj.onclick=Insert_click;
	var obj=document.getElementById('UPDATE')
	if(obj) obj.onclick=Update_click;
	var obj=document.getElementById('DELETE')
	if(obj) obj.onclick=Delete_click;
	/*
	var obj=document.getElementById("icucioiStrategyDesc");
	if (obj) obj.onblur=IcucioiStrategyDesc_onblur;
	var obj=document.getElementById("icucioiDrDesc");
	if (obj) obj.onblur=IcucioiDrDesc_onblur;
	
	var obj=document.getElementById("icucioiTypeDesc");
	if (obj) obj.onblur=IcucioiTypeDesc_onblur;
	var obj=document.getElementById("ancoDesc");
	if (obj) obj.onblur=AncoDesc_onblur;
	var obj=document.getElementById("ancvcDesc");
	if (obj) obj.onblur=AncvcDesc_onblur;
	var obj=document.getElementById("phcinDesc");
	if (obj) obj.onblur=PhcinDesc_onblur;
	var obj=document.getElementById("icucioiActiveDesc");
	if (obj) obj.onblur=IcucioiActiveDesc_onblur;
	var obj=document.getElementById("ctlocDesc");
	if (obj) obj.onblur=CtlocDesc_onblur;
	*/
	SetFilter("tDHCICUCIOItem","icucioiCode","tIcucioiCode");
	SetFilter("tDHCICUCIOItem","ancoDesc","tAncoDesc");
	SetFilter("tDHCICUCIOItem","icucioiDesc","tIcucioiDesc");
	SetFilter("tDHCICUCIOItem","phcinDesc","tPhcinDesc");
	SetFilter("tDHCICUCIOItem","icucioiTypeDesc","tIcucioiTypeDesc");
	SetFilter("tDHCICUCIOItem","ancvcDesc","tAncvcDesc");
	SetFilter("tDHCICUCIOItem","ctlocDesc","tCtlocDesc");
	SetFilter("tDHCICUCIOItem","icucioiStrategyDesc","tIcucioiStrategyDesc");

	
	//SetFilter("tDHCICUCIOItem","ancoDesc");
	
	$("#tDHCICUCIOItem thead tr th").each(function(){
	    $(this).attr("sort","true");
	    });
    $("#tDHCICUCIOItem").sort({
			'ascImgUrl':'../scripts/dhcclinic/jQuery/images/bullet_arrow_up.png',  //升序图片
			'descImgUrl':'../scripts/dhcclinic/jQuery/images/bullet_arrow_down.png', //降序图片
			'endRow':0		//需要排序的最后一行  -1代表  倒数第二行
		});
	$("#tDHCICUCIOItem thead tr th").click(function(){	    	
			$(":checkbox").attr("checked",$(this).attr("checked"));
		});
	$("#tDHCICUCIOItem tbody tr").click(function(){
		if(selRow)
		$(selRow).removeClass("clsRowSelected");
		selRow = this;
		preSelectRow = selectRow;
		selectRow = this.rowIndex;
		// $("#tDHCICUCIOItem tbody tr").removeClass("clsRowSelected");
        $(this).toggleClass("clsRowSelected");
        var rowId=$(this).children("td").eq(1).text();
        
        $(this).children("td").each(function(){	
        		if($(this).html()=="")return;
	        	var id=$(this).children("LABEL")[0].id;
	        	var lastIndex=id.lastIndexOf('z');
	        	var ctrlName=id.substring(2,lastIndex);
	        	var ch1=id.charAt(1);
		    	var value = $(this).children("LABEL").eq(0).text();
		    	if(value == " ")value="";
		    	upperName="#"+ch1.toUpperCase()+ctrlName;
		    	lowerName="#"+ch1.toLowerCase()+ctrlName;
		    	if($(upperName).length != 0) $(upperName).val(value);
		        else if($(lowerName).length != 0)
		        $(lowerName).val(value);
	        });
		});
}
	
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	selectRow=rowObj.rowIndex;
	if (!selectRow) return;
	
	if (preSelectRow!=selectRow)
	{
		SetElementByElement('icucioiId',"V",'tIcucioiIdz'+selectRow,"I"," ","");
		SetElementByElement('icucioiCode',"V",'tIcucioiCodez'+selectRow,"I"," ","");
		SetElementByElement('icucioiDesc',"V",'tIcucioiDescz'+selectRow,"I"," ","");
		SetElementByElement('icucioiTypeDesc',"V",'tIcucioiTypeDescz'+selectRow,"I"," ","");
		SetElementByElement('icucioiType',"V",'tIcucioiTypez'+selectRow,"I"," ","");
		SetElementByElement('ancoDesc',"V",'tAncoDescz'+selectRow,"I"," ","");
		SetElementByElement('ancoId',"V",'tAncoIdz'+selectRow,"I"," ","");
		SetElementByElement('ancvcDesc',"V",'tAncvcDescz'+selectRow,"I"," ","");
		SetElementByElement('ancvcId',"V",'tAncvcIdz'+selectRow,"I"," ","");
		SetElementByElement('phcinDesc',"V",'tPhcinDescz'+selectRow,"I"," ","");
		SetElementByElement('phcinId',"V",'tPhcinIdz'+selectRow,"I"," ","");
		SetElementByElement('icucioiActiveDesc',"V",'tIcucioiActiveDescz'+selectRow,"I"," ","");
		SetElementByElement('icucioiActive',"V",'tIcucioiActivez'+selectRow,"I"," ","");
		SetElementByElement('ctlocDesc',"V",'tCtlocDescz'+selectRow,"I"," ","");
		SetElementByElement('ctlocId',"V",'tCtlocIdz'+selectRow,"I"," ","");
		SetElementByElement('icucioiDr',"V",'tIcucioiDrz'+selectRow,"I"," ","");
		SetElementByElement('icucioiStrategy',"V",'tIcucioiStrategyz'+selectRow,"I"," ","");
 		SetElementByElement('icucioiStrategyDesc',"V",'tIcucioiStrategyDescz'+selectRow,"I"," ","");
 		SetElementByElement('icucioiDrDesc',"V",'tIcucioiDrDescz'+selectRow,"I"," ","");
		SetElementByElement('icucioiMultiple',"V",'tIcucioiMultiplez'+selectRow,"I"," ","");
		SetElementByElement('icucioiValueField',"V",'tIcucioiValueFieldz'+selectRow,"I"," ","");


		preSelectRow=selectRow;
	}
	else
	{
		SetElementValue('icucioiId',"V","");
		SetElementValue('icucioiCode',"V","");
		SetElementValue('icucioiDesc',"V","");
		SetElementValue('icucioiType',"V","");
		SetElementValue('icucioiTypeDesc',"V","");
		SetElementValue('ancoDesc',"V","");
		SetElementValue('ancoId',"V","");
		SetElementValue('ancvcDesc',"V","");
		SetElementValue('ancvcId',"V","");
		SetElementValue('phcinDesc',"V","");
		SetElementValue('phcinId',"V","");
		SetElementValue('icucioiActiveDesc',"V","");
		SetElementValue('icucioiActive',"V","");
		SetElementValue('ctlocDesc',"V","");
		SetElementValue('ctlocId',"V","");
		SetElementValue('icucioiDr',"V","");
		SetElementValue('icucioiDrDesc',"V","");
		SetElementValue('icucioiStrategy',"V","");
		SetElementValue('icucioiStrategyDesc',"V","");
		SetElementValue('icucioiMultiple',"V","");
		SetElementValue('icucioiValueField',"V","");

		preSelectRow=-1
		selectRow=0
	}
}

function Insert_click()
{
	//if (selectRow>0) return;
	/*
	var icucioiCode=GetElementValue('icucioiCode',"V");
	var icucioiDesc=GetElementValue('icucioiDesc',"V");
	var icucioiType=GetElementValue('icucioiType',"V");
	var ancoId=GetElementValue('ancoId',"V");
	var ancvcId=GetElementValue('ancvcId',"V");
	var phcinId=GetElementValue('phcinId',"V");
	var icucioiActive=GetElementValue('icucioiActive',"V");
	var ctlocId=GetElementValue('ctlocId',"V");
	var icucioiDr=GetElementValue('icucioiDr',"V");
	var icucioiStrategy=GetElementValue('icucioiStrategyDesc',"V");
    var icucioiMultiple=GetElementValue('icucioiMultiple',"V");
	var icucioiValueField=GetElementValue('icucioiValueField',"V");
	var obj=document.getElementById('InsertICUCIOItem')
	*/
	var icucioiCode=GetCtrlVal('icucioiCode');
	var icucioiDesc=GetCtrlVal('icucioiDesc');
	var icucioiType=GetCtrlVal('icucioiType');
	var ancoId=GetCtrlVal('ancoId');
	var ancvcId=GetCtrlVal('ancvcId');
	var phcinId=GetCtrlVal('phcinId');
	var icucioiActive=GetCtrlVal('icucioiActive');
	var ctlocId=GetCtrlVal('ctlocId');
	var icucioiDr=GetCtrlVal('icucioiDr');
	var icucioiStrategy=GetCtrlVal('icucioiStrategyDesc');
    var icucioiMultiple=GetCtrlVal('icucioiMultiple');
	var icucioiValueField=GetCtrlVal('icucioiValueField');
	
	// 类型
	var icucioiTypeDesc=GetCtrlVal("icucioiTypeDesc");
	if(icucioiTypeDesc=="")icucioiType="";
	// 用法
	var phcinDesc=GetCtrlVal("phcinDesc");
	if(phcinDesc=="")phcinId="";
	// 科室
	var ctlocDesc=GetCtrlVal("ctlocDesc");
	if(ctlocDesc=="")ctlocId="";
	// 显示分类
	var ancvcDesc=GetCtrlVal("ancvcDesc");
	if(ancvcDesc=="")ancvcId="";
	// 常用医嘱
	var ancoDesc=GetCtrlVal("ancoDesc");
	if(ancoDesc=="")ancoId="";
	// 主项名称
	var icucioiDrDesc=GetCtrlVal("icucioiDrDesc");
	if(ancoDesc=="")icucioiDr="";
	var obj=document.getElementById('InsertICUCIOItem')
	
	if(obj) 
	{
		var insertICUCIOItem=obj.value;
		var retStr=cspRunServerMethod(insertICUCIOItem,icucioiCode,icucioiDesc,icucioiType,ancoId,ancvcId,phcinId,icucioiActive,ctlocId,icucioiDr,icucioiStrategy,icucioiMultiple,icucioiValueField);
		if (retStr!=0) alert(retStr);
		else Find_click();
	}
}

function Update_click(){
	if (selectRow<1) return;
	/*
	var icucioiId=GetElementValue('icucioiId',"V");
	var icucioiCode=GetElementValue('icucioiCode',"V");
	var icucioiDesc=GetElementValue('icucioiDesc',"V");
	var icucioiType=GetElementValue('icucioiType',"V");
	var ancoId=GetElementValue('ancoId',"V");
	var ancvcId=GetElementValue('ancvcId',"V");
	var phcinId=GetElementValue('phcinId',"V");
	var icucioiActive=GetElementValue('icucioiActive',"V");
	var ctlocId=GetElementValue('ctlocId',"V");
	var icucioiDr=GetElementValue('icucioiDr',"V");
	var icucioiStrategy=GetElementValue('icucioiStrategyDesc',"V");
	var icucioiMultiple=GetElementValue('icucioiMultiple',"V");
	var icucioiValueField=GetElementValue('icucioiValueField',"V");
	*/
	var icucioiId=GetCtrlVal('icucioiId');
	var icucioiCode=GetCtrlVal('icucioiCode');
	var icucioiDesc=GetCtrlVal('icucioiDesc');
	var icucioiType=GetCtrlVal('icucioiType');
	var ancoId=GetCtrlVal('ancoId');
	var ancvcId=GetCtrlVal('ancvcId');
	var phcinId=GetCtrlVal('phcinId');
	var icucioiActive=GetCtrlVal('icucioiActive');
	var ctlocId=GetCtrlVal('ctlocId');
	var icucioiDr=GetCtrlVal('icucioiDr');
	var icucioiStrategy=GetCtrlVal('icucioiStrategyDesc');
	var icucioiMultiple=GetCtrlVal('icucioiMultiple');
	var icucioiValueField=GetCtrlVal('icucioiValueField');
	
	// 类型
	var icucioiTypeDesc=GetCtrlVal("icucioiTypeDesc");
	if(icucioiTypeDesc=="")icucioiType="";
	// 用法
	var phcinDesc=GetCtrlVal("phcinDesc");
	if(phcinDesc=="")phcinId="";
	// 科室
	var ctlocDesc=GetCtrlVal("ctlocDesc");
	if(ctlocDesc=="")ctlocId="";
	// 显示分类
	var ancvcDesc=GetCtrlVal("ancvcDesc");
	if(ancvcDesc=="")ancvcId="";
	// 常用医嘱
	var ancoDesc=GetCtrlVal("ancoDesc");
	if(ancoDesc=="")ancoId="";
	// 主项名称
	var icucioiDrDesc=GetCtrlVal("icucioiDrDesc");
	if(ancoDesc=="")icucioiDr="";
	var obj=document.getElementById('UpdateICUCIOItem')
	if(obj) 
	{
		//alert(icucioiId+"/"+icucioiCode+"/"+icucioiDesc+"/"+icucioiType+"/"+ancoId+"/"+ancvcId+"/"+phcinId+"/"+icucioiActive+"/"+ctlocId)
		var retStr=cspRunServerMethod(obj.value,icucioiId,icucioiCode,icucioiDesc,icucioiType,ancoId,ancvcId,phcinId,icucioiActive,ctlocId,icucioiDr,icucioiStrategy,icucioiMultiple,icucioiValueField);
		if (retStr!=0) alert(retStr);
		else Find_click();
	}
}

function Delete_click(){
	if (selectRow<1) return;
	var icucioiId=$('#tIcucioiIdz'+selectRow).text();
	
	var obj=document.getElementById('DeleteICUCIOItem')
	if(obj) 
	{
		var deleteICUCIOItem=obj.value;
		retStr=cspRunServerMethod(deleteICUCIOItem,icucioiId);
		if (retStr!=0) alert(retStr);
		else Find_click();
	}	
}
function GetStrategy(value)
{
	SetElementFromListByName('icucioiStrategy',"V",'icucioiStrategyDesc',"V",value,"^",0,1)
}
function IcucioiStrategyDesc_onblur()
{
	SetAttachElementByName("icucioiStrategyDesc","V","","icucioiStrategy","V","");
}
function GetIcucioiDr(value)
{
	SetElementFromListByName('icucioiDr',"V",'icucioiDrDesc',"V",value,"^",0,1)
}
function IcucioiDrDesc_onblur()
{
	SetAttachElementByName("IcucioiDrDesc","V","","icucioiDr","V","");
}

function GetType(value)
{
	SetElementFromListByName('icucioiType',"V",'icucioiTypeDesc',"V",value,"^",0,1)
}
function IcucioiTypeDesc_onblur()
{
	SetAttachElementByName("icucioiTypeDesc","V","","icucioiType","V","");
}
function GetCommonOrd(value)
{
	SetElementFromListByName('ancoId',"V",'ancoDesc',"V",value,"^",0,2)
}
function AncoDesc_onblur()
{
	SetAttachElementByName("ancoDesc","V","","ancoId","V","");
}
function GetViewCat(value)
{
	SetElementFromListByName('ancvcId',"V",'ancvcDesc',"V",value,"^",0,1)
}
function AncvcDesc_onblur()
{
	SetAttachElementByName("ancvcDesc","V","","ancvcId","V","");
}
function GetActive(value)
{
	SetElementFromListByName('icucioiActive',"V",'icucioiActiveDesc',"V",value,"^",0,1)
}
function GetValueField(value)
{
	SetElementFromListByName('icucioiValueFieldId',"V",'icucioiValueField',"V",value,"^",0,1)
}
function IcucioiActiveDesc_onblur()
{
	SetAttachElementByName("icucioiActiveDesc","V","","icucioiActive","V","");
}
function LookUpInstruc(value)
{
	SetElementFromListByName('phcinDesc',"V",'phcinId',"V",value,"^",0,1)
}
function PhcinDesc_onblur()
{
	SetAttachElementByName("phcinDesc","V","","phcinId","V","");
}
function GetCtloc(value)
{
	SetElementFromListByName('ctlocId',"V",'ctlocDesc',"V",value,"^",1,0)
}

function CtlocDesc_onblur()
{
	SetAttachElementByName("ctlocDesc","V","","ctlocId","V","");
}
function selitem(selbox,delimStr)
{
      var tmpList=new Array();
        for ( var i=0;i<selbox.options.length;i++)
		{   
			if (selbox.options[i].selected)
			{   
			    tmpList[tmpList.length]=selbox.options[i].value
			}
		}
		if (tmpList[0]=="") tmpList=tmpList.slice(1)
		var Str=tmpList.join(delimStr);
  return Str
}
function SelectedSet(selObj,indStr,delim) 
{
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
document.body.onload=BodyLoadHandler;