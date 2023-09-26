var preSelectRow=-1;
var selectRow = 0;
var selRow = null;
function BodyLoadHandler()
{
	var obj=document.getElementById("Modify");
	if (obj) obj.onclick=Update_click;
	var obj=document.getElementById("Remove");
	if (obj) obj.onclick=Delete_click;
	var obj=document.getElementById("Add");
	if (obj) obj.onclick=Add_click;
	var obj=document.getElementById("Find");
	if (obj) obj.onclick = Find_click;
	$("#filterEdit").bind('textchange', function () {
        var fStr = $(this).val();
        $("#tDHCICUDisplayItems > tbody> tr").each(function () {
	        fStr=fStr.toUpperCase();
	        fStr.replace(" ","+");
            var strArray = fStr.split('+');
            
            var obj = $(this);
            var text = obj.html();
			text=text.toUpperCase();
            var isFind = true;

            for (var i = 0; i < strArray.length; i++) {
                if (text.indexOf(strArray[i]) < 0) {
                    isFind = false;
                    break;
                }
            }
            if (fStr == "") isFind = true;
            if (isFind) {
                obj.show();
            }
            else obj.hide();
        });
    });
    
    var objtbl=document.getElementById('tDHCICUDisplayItems');
    for (var i=1;i<objtbl.rows.length;i++)
    {
	    var	obj=document.getElementById('TSeqNoz'+i);
	    if (obj) obj.onkeydown=UpdateKeyDown;
    }
    $("#tDHCICUDisplayItems thead tr th").each(function(){
	    $(this).attr("sort","true");
	    });
    $("#tDHCICUDisplayItems").sort({
			'ascImgUrl':'../scripts/dhcclinic/jQuery/images/bullet_arrow_up.png',  //升序图片
			'descImgUrl':'../scripts/dhcclinic/jQuery/images/bullet_arrow_down.png', //降序图片
			'endRow':0,		//需要排序的最后一行  -1代表  倒数第二行
			'defaultSortCol':4
		});
		
    $("#tDHCICUDisplayItems thead tr th").click(function(){	    	
			$(":checkbox").attr("checked",$(this).attr("checked"));
		});
	$("#tDHCICUDisplayItems tbody tr").click(function(){
		selRow = this;
		preSelectRow = selectRow;
		selectRow = this.rowIndex;
		$("#tDHCICUDisplayItems tbody tr").removeClass("clsRowSelected");
        $(this).toggleClass("clsRowSelected");
        var rowId=$(this).children("td").eq(1).text();
        
        $(this).children("td").each(function(){
	        try
	        {
	        	var id=$(this).children("LABEL")[0].id;
	        	var lastIndex=id.lastIndexOf('z');
	        	var ctrlName=id.substring(1,lastIndex);
		    	var value = $(this).children("LABEL").eq(0).text();
		    	if(value == "&nbsp;")value="";
		        $("#"+ctrlName).val(value);
	        }
	        catch(ex)
	        {
		    }
	        });
		//parent.frames['RPBottom'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCICUDisplayProperties&DisplayItemID=" + rowId; 
		});
	$("#tDHCICUDisplayItems tbody tr").dblclick(function(){
		selRow = this;
		preSelectRow = selectRow;
		selectRow = this.rowIndex;
		$("#tDHCICUDisplayItems tbody tr").removeClass("clsRowSelected");
        $(this).toggleClass("clsRowSelected");
        var rowId=$(this).children("td").eq(1).text();
        
        $(this).children("td").each(function(){
	        try
	        {
	        	var id=$(this).children("LABEL")[0].id;
	        	var lastIndex=id.lastIndexOf('z');
	        	var ctrlName=id.substring(1,lastIndex);
		    	var value = $(this).children("LABEL").eq(0).text();
		    	if(value == "&nbsp;")value="";
		        $("#"+ctrlName).val(value);
	        }
	        catch(ex)
	        {
		    }
	        });
		parent.frames['RPBottom'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCICUDisplayProperties&DisplayItemID=" + rowId; 
	});
	$(document).keyup(function(event){ 
	if(selRow == null)return ;
	var swapRow=null;
	if(event.keyCode==38)
	{
		// up
		var swapRow = $(selRow).prev();
	}
	else if(event.keyCode==40)
	{
		// down
		var swapRow = $(selRow).next();
	}
	else return;
	if(swapRow[0]){
		if (event.altKey ) {
			// 若Alt键按下则调整顺序
		SwapRow(selRow,swapRow);
		
		}
		// 调整被选项
		selRow = swapRow;
		preSelectRow = selectRow;
		selectRow = swapRow.rowIndex;
		$("#tDHCICUDisplayItems tbody tr").removeClass("clsRowSelected");
    	$(selRow).toggleClass("clsRowSelected");
    	$("html body").animate({scrollTop: $(selRow).offset().top-100}, 1); 
	}
	}); 
	$("#tDHCICUDisplayItems thead tr").attr({title:"选中行，按Alt+↑或↓ 调整顺序\r双击行查看属性"});
}
function Find_click()
{
	ICUPIComOrdId=document.getElementById("ComOrdID").value;
	ICUPIComOrd=document.getElementById("ComOrd").value;
	ICUPIViewCatId=document.getElementById("ViewCatID").value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCICUParaItem&ctlocId=&ICUPIViewCatId="+ICUPIViewCatId+"&ICUPIComOrd="+ICUPIComOrd;
	location.href=lnk; 

}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCICUDisplayItems');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	selectRow=rowObj.rowIndex;
	if (!selectRow) return;
	var itemID ="";
	
	if (preSelectRow!=selectRow)
	{
		/*
	    SetElementByElement('ItemCode',"V",'TItemCodez'+selectRow,"I"," ","");
	    SetElementByElement("ItemDesc","V", "TItemDescz" + selectRow,"I"," ","");
	    SetElementByElement("ComOrd","V", "TComOrdDescz" + selectRow,"I"," ","");
	    SetElementByElement("ViewCat","V", "TViewCatDescz" + selectRow,"I"," ","");
	    SetElementByElement("SeqNo","V", "TSeqNoz" + selectRow,"I"," ","");
	    SetElementByElement("ID","V", "TIDz" + selectRow,"I"," ","");
	    SetElementByElement("ComOrdID","V", "TComOrdIDz" + selectRow,"I"," ","");
	    SetElementByElement("ViewCatID","V", "TViewCatIDz" + selectRow,"I"," ","");
	    SetElementByElement("TemplateID","V", "TTemplateIDz" + selectRow,"I"," ","");
		*/
	    preSelectRow = selectRow;
	    itemID = GetElementValue("ID","V");
	}
	else
	{
		/*
	    SetElementValue('ItemCode',"V","");
	    SetElementValue("ItemDesc","V","");
	    SetElementValue("ComOrd","V","");
	    SetElementValue("ViewCat","V","");
	    SetElementValue("SeqNo","V","");
	    SetElementValue("ID","V","");
	    SetElementValue("ComOrdID","V","");
	    SetElementValue("ViewCatID","V","");
	    SetElementValue("TemplateID","V","");
		*/
		preSelectRow=-1
		selectRow=0
	}
	parent.frames['RPBottom'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCICUDisplayProperties&DisplayItemID=" + itemID; 
	//this.focus();
}
function Update_click()
{
	if (selectRow<1) return;
	var obj=document.getElementById('ModifyItem');
	if(obj) 
	{
	    var itemID = document.getElementById("ID").value;
	    var templateID = document.getElementById("TemplateID").value;
	    var comOrdID = document.getElementById("ComOrdID").value;
	    var viewCatID = document.getElementById("ViewCatID").value;
	    var seqNo = document.getElementById("SeqNo").value;
	    var code = document.getElementById("ItemCode").value;
	    var desc = document.getElementById("ItemDesc").value;
	    retStr = cspRunServerMethod(obj.value, itemID, templateID, comOrdID, viewCatID, seqNo, code, desc);
	    if (retStr!=0) alert(retStr);
		else 
		{
			//alert("成功修改数据!");
			//self.location.reload();
			//  修改列表中的数据
			var idTag = "";
			 $(selRow).children("td").each(function(){
				if($(this).children("LABEL").length<=0)return;
	        	var id=$(this).children("LABEL")[0].id;
	        	var lastIndex=id.lastIndexOf('z');
	        	var ctrlName=id.substring(1,lastIndex);
	        	if(id.indexOf("TIDz"))idTag=id;
	        	var itemValue = $("#"+ctrlName).val();
	        	$(this).children("LABEL").eq(0).text(itemValue);        	
	        });
	        return;
	        TbSort($("#tDHCICUDisplayItems"),"asc",4);
	        $("#tDHCICUDisplayItems tbody tr").removeClass("clsRowSelected");
	        $("#"+idTag).parent().parent().toggleClass("clsRowSelected");
		}
	}
}
function Delete_click()
{
	if (selectRow<1) return;
	var obj=document.getElementById('RemoveItem')
	if(obj) {
	    var itemID = document.getElementById("ID").value;
	    var retStr = cspRunServerMethod(obj.value, itemID);
		if (retStr!=0) alert(retStr);
		else 
		{
			$(selRow).remove();
			selectRow=-1;
			selRow=null;
			//alert("成功删除数据!");
			//self.location.reload();
		}
	}
}

//
function Add_click()
{
	var obj=document.getElementById('AddItem');
	if(obj) {
	    var comOrdID = document.getElementById("ComOrdID").value;
	    var seqNo = document.getElementById("SeqNo").value;
	    var viewCatID = document.getElementById("ViewCatID").value;
	    var code = document.getElementById("ItemCode").value;
	    var desc = document.getElementById("ItemDesc").value;
	    var templateID = parent.frames['RPTop'].document.getElementById("TemplateID").value;
	    
	    retStr = cspRunServerMethod(obj.value, comOrdID, seqNo, viewCatID, code, desc, templateID);
		if (retStr!=0) alert(retStr);
		else 
		{
			alert("成功插入数据!");
			//self.location.reload();
		}
	}
}


function GetAppLoc(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("LocId")
	if (obj){obj.value=loc[1]}
	var objLocId=document.getElementById("LocId")
	if(objLocId) {objLocId.value=loc[0];}
	LocId=loc[0];
}
function GetComOrd(str)
{
	var value=str.split("^");
	var ComOrdObj=document.getElementById("ComOrdDesc")
	if (ComOrdObj){ComOrdObj.value=value[2]}
	var ComOrdIDObj=document.getElementById("ComOrdID")
	if (ComOrdIDObj){ComOrdIDObj.value=value[0]}
}
function GetViewCat(str)
{
	var value=str.split("^");
	var ViewCatObj=document.getElementById("ViewCatDesc")
	if (ViewCatObj){ViewCatObj.value=value[2]}
	var ViewCatIDObj=document.getElementById("ViewCatID")
	if (ViewCatIDObj){ViewCatIDObj.value=value[0]}
	
}

function UpdateKeyDown(){
	if (window.event.keyCode!=13) return;
	var eSrc=window.event.srcElement;
	var cellname=eSrc.name;
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;	
	var selectCol=GetSelectCol(cellname);
	alert(cellname);
	itemID = GetElementValue("ID","V");
	if(cellname!="TSeqNoz")
	parent.frames['RPBottom'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCICUDisplayProperties&DisplayItemID=" + itemID; 

	return;
	var objSelrow=document.getElementById("selrow");
    objSelrow.value=selectrow;
	if (!selectrow) return;
	
	alert(objSelrow.value);
}
function GetSelectCol(cellStr)
{
	var i=cellStr.length;
	var str = cellStr.replace(/\d+/g,'');

	return str;
}
//将数据进行排序
/*
function TbSort(p, sort,index) {
    data = new Array();
    //所选的行
    var trBodyList = $(p).find("tr:lt(" + $(p).find("tr").size() + "):gt(" + 0 + ")");
    trBodyList.each(function (i) {
        data[i] = new Array();
        $(this).find("td").each(function (j) {
            data[i][j] = $(this).html();
        });
    });
    data.sort(function (x, y) {
	    var a=$(x[index]).text();
		var b=$(y[index]).text();
		if(!isNaN(a) && !isNaN(a)){
		a=parseFloat($(x[index]).text());
		b=parseFloat($(y[index]).text());
		//return a-b;
		if(sort=='asc') return a-b;
			else return b-a;
		}
        if (sort == 'asc') {
            return x[index].localeCompare(y[index]);
        } else {
            return y[index].localeCompare(x[index]);
        }
    });
    trBodyList.each(function (i) {
        $(this).find("td").each(function (j) {
            $(this).html(data[i][j]);
        });
    });
    }
    */
 function SwapRow(srcRow,dstRow)
 {
	var srcReq=$(srcRow).children("td").eq(4).children("LABEL").text();
	var dstReq=$(dstRow).children("td").eq(4).children("LABEL").text();
	$(srcRow).children("td").eq(4).children("LABEL").text(dstReq);
	$(dstRow).children("td").eq(4).children("LABEL").text(srcReq);
	var i=0;
	$(srcRow).children("td").each(function(){
		if(i == 0){
			i++;
			return;
		}
		var srcValue=$(srcRow).children("td").eq(i).children("LABEL").text();
		var dstValue=$(dstRow).children("td").eq(i).children("LABEL").text();
		$(srcRow).children("td").eq(i).children("LABEL").text(dstValue);
		$(dstRow).children("td").eq(i).children("LABEL").text(srcValue);
		i++;
		});
	Update($(srcRow));
	Update($(dstRow));
	
 }
 function Update(row)
{
	var RowId=row.children("td").eq(1).children("LABEL").text();
	var tICUPIId = document.getElementById("TemplateID").value;
	var ICUPIComOrdDr=row.children("td").eq(7).children("LABEL").text();
	var ICUPIViewCatDr=row.children("td").eq(8).children("LABEL").text();
	var ICUPISeqNo=row.children("td").eq(4).children("LABEL").text();
	var ICUPICode=row.children("td").eq(2).children("LABEL").text();
	var ICUPIDesc=row.children("td").eq(3).children("LABEL").text();
	var obj=document.getElementById('UpdateICUParaItemReqNo');
	
	if(obj) 
	{
		// retStr = cspRunServerMethod(obj.value,RowId, tICUPIId, ICUPIComOrdDr, ICUPIViewCatDr, ICUPISeqNo, ICUPICode, ICUPIDesc);
	    retStr = cspRunServerMethod(obj.value,RowId, ICUPISeqNo);
	    return retStr;
	}
	return -1;
}
document.body.onload=BodyLoadHandler;
