var oldobj;
var TimeRangeAppExt={
	SeqNo1:"",
	AppSeqNo:"",
	AppTimeRange:"",
	mainpanel:null
}
function tdclick(obj){
	if(oldobj!=null){
		oldobj.style.backgroundColor='#e6f2ff'	
	}
	if(oldobj==obj){
		TimeRangeAppExt.SeqNo1=""
		obj.style.backgroundColor='#e6f2ff';	
	}else{
		oldobj=obj;
		obj.style.backgroundColor='#BDDDFF';
		TimeRangeAppExt.SeqNo1=obj.id	
	}
	
}
function mouserout(obj){
	if(oldobj==obj){
		return ;	
	}	
	obj.style.backgroundColor='#e6f2ff'
}
function mouserover(obj){
	if(oldobj==obj){
		return ;	
	}	
	obj.style.backgroundColor='#BDDDFF'
}
function dbtdclick(obj){
	if(obj){
		TimeRangeAppExt.AppSeqNo=obj.id
		TimeRangeAppExt.AppTimeRange=obj.TimeRange
		var ret=AddBeforeUpdate();
		if (ret) {
			websys_setfocus('tDHCOPAdm_Reg');
			websys_setfocus('Appoint');
		}
		TimeRangeAppExt.AppSeqNo=""
	}
}
function ShowTimeRange(ASRowid,PositionElName,AppMethodCode,posStyle){
	var newdiv=document.getElementById("ExtApp")
	if (posStyle) newdiv.setAttribute('style',posStyle);
	//默认按诊间预约方式预约
	AppMethodCode=AppMethodCode||"DOC";
	var xdata=tkMakeServerCall("web.DHCOPAdmReg","GetTimeRangeStrApp",ASRowid,AppMethodCode);
	tpl2.compile();
	var xdata=Ext.decode(xdata)
	tpl2.overwrite(TimeRangeAppExt.mainpanel.body,xdata);
	TimeRangeAppExt.mainpanel.doLayout()
	
	var PositionElObj=document.getElementById(PositionElName);
	if (PositionElObj) {
		//设置显示panel的宽和高
		// var PrivateListHieght=PositionElObj.offsetHeight
		// TimeRangeAppExt.mainpanel.setHeight(PrivateListHieght+40);
		// TimeRangeAppExt.mainpanel.doLayout()	
		
		/*//newdiv.style.width=PositionElObj.offsetWidth
		if(document.body.offsetWidth>PositionElObj.offsetWidth){
			TimeRangeAppExt.mainpanel.setWidth(document.body.offsetWidth)
		}else{
			TimeRangeAppExt.mainpanel.setWidth(PositionElObj.offsetWidth+20)	
		}
		//TimeRangeAppExt.mainpanel.doLayout()
		//设置显示panel的位置*/

		TimeRangeAppExt.mainpanel.doLayout()

	}	
}


(function (){
	var AppFlagObj=document.getElementById("AppFlag");
	if (AppFlagObj) {
		var AppFlag=DHCC_GetElementData("AppFlag")
		if (AppFlag!=1) return false;
	}
	var newdiv = document.createElement("div");
	newdiv.setAttribute("id","ExtApp")	
	if (AppFlagObj) newdiv.style.display="none" //newdiv.style="display:none;"
	//var tableObj=document.getElementById("fDHCOPAdm_Reg_MarkListCopy")
	//tableObj.parentNode.insertBefore(newdiv,tableObj.nextSibling)

	Ext.getBody().appendChild(newdiv);

	//ondblclick="TabDblclick()"
	tpl2=new Ext.XTemplate(
			'<table border="0"   id="{record}"  class="diytable" cellspacing="1" cellpadding="0" >',
       		'<tpl for="row">',
       		'<tr height=20>',
       		'<td  width=160 bgcolor="#BEBEBE" style="text-align:center"><font color="black" size=2><b>{TimeRange}</b></font></td>',
       		'<tpl for="col">',
       		'<tpl if="Status==2")><td class="diytd3" style="text-align:center" width=200 id={SeqNo}><font color=red size=5>{SeqNo}</font><br><font color=black>{Time}</font></tpl>',
       		'<tpl if="Status!=2"><td class="diytd3" onmouseover=mouserover(this) onmouseout=mouserout(this) onclick=tdclick(this) ondblclick=dbtdclick(this) style="text-align:center" width=200 id={SeqNo}><font color=blue size=5>{SeqNo}</font><br><font color=black>{Time}</font></tpl>',
       		'</td>',
       		'</tpl>',
       		'</tr>',
       		'</tpl>',
       		'</table>'
     )
      TimeRangeAppExt.mainpanel=new Ext.Panel({
		id:"MainPanel",
		title:'分时段预约',
		//width:document.body.offsetWidth,
		//width:Ext.getBody().dom.offsetWidth,
		frame:true,
    	renderTo:"ExtApp"
	})
})();
//Ext.onReady(init);