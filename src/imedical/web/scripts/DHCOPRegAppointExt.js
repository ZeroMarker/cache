var oldobj;
var PanelId="MainPanel"
var TimeRangeAppExt={
	SeqNo1:"",
	AppSeqNo:"",
	AppTimeRange:"",
	mainpanel:null,
	Tleft:null,
	Ttopl:null
}
function tdclick(obj){
	if(oldobj!=null){
		oldobj.style.backgroundColor='#e6f2ff'	
	}
	if(oldobj==obj){
		TimeRangeAppExt.AppSeqNo=""
		obj.style.backgroundColor='#e6f2ff';	
	}else{
		oldobj=obj;
		obj.style.backgroundColor='#BDDDFF';
		TimeRangeAppExt.AppSeqNo=obj.id	
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
function ShowTimeRange(ASRowid,AppLoadCell){
	if (AppLoadCell) {
		var el = Ext.get(AppLoadCell);
	}else{
		var el = Ext.get("AppLoadz"+selectedRowObj.rowIndex);
	}
	var extxy = el.getAnchorXY();
	var width = el.dom.offsetWidth;
	if (typeof newdiv == "undefined") { 
		init()
	}
	newdiv.style.top=extxy[1]+20
	newdiv.style.left=extxy[0]+20
	TimeRangeAppExt.Ttopl=(extxy[1]+20)
	TimeRangeAppExt.Tleft=(extxy[0]+20)
	newdiv.style.width=2000   //AppTimeRange.offsetWidth
	TimeRangeAppExt.mainpanel.setVisible(true)
	TimeRangeAppExt.mainpanel.expand()
	var xdata=tkMakeServerCall("web.DHCOPAdmReg","GetTimeRangeStrApp",ASRowid,"WIN")
	tpl2.compile();
	var xdata=Ext.decode(xdata)
	tpl2.overwrite(TimeRangeAppExt.mainpanel.body,xdata);
	if(xdata.row=="") {
		TimeRangeAppExt.mainpanel.setVisible(false)	
		return 
		
	}
	var el1=Ext.get("MainPanel")
	var AppTimeRange1=document.getElementById("AppTimeRange")
	newdiv.style.width=AppTimeRange1.offsetWidth
	TimeRangeAppExt.mainpanel.doLayout()
	//var PrivateListHieght=document.getElementById("fDHCOPDoc_Appoint").offsetHeight
	//TimeRangeAppExt.mainpanel.setHeight(PrivateListHieght+40);
	//TimeRangeAppExt.mainpanel.doLayout()	
}
	
var init = function(){
	newdiv = document.createElement("div");
	newdiv.setAttribute("id","ExtApp")
	newdiv.setAttribute("overflow","hidden")
	newdiv.onselectstart="return false"
	document.body.appendChild(newdiv);
	newdiv.style.top=120
	newdiv.style.left=600
	newdiv.style.position="absolute"
	tpl2=new Ext.XTemplate(
			'<table border="0" id="{record}"  class="diytable" cellspacing="1" cellpadding="0" >',
       		'<tpl for="row">',
       		'<tr height=20>',
       		'<td width= 150 bgcolor="#BEBEBE" onselectstart="return false" style="text-align:center"><font color="black" size=2><b>{TimeRange}</b></font></td>',
       		'<tpl for="col">',
       		'<tpl if="Status==2"><td width= 100 onselectstart="return false" class="diytd3" style="text-align:center"  id={SeqNo}><font color=red size=5>{SeqNo}</font><br><font color=black>{Time}</font></tpl>',
       		'<tpl if="Status!=2"><td width= 100 onselectstart="return false" class="diytd3" onmouseover=mouserover(this) TimeRange={Time} onmouseout=mouserout(this) onclick=tdclick(this) ondblclick=dbtdclick(this) style="text-align:center" width=200 id={SeqNo}><font color=blue size=5>{SeqNo}</font><br><font color=black>{Time}</font></tpl>',
       		'</td>',
       		'</tpl>',
       		'</tr>',
       		'</tpl>',
       		'</table>'
     )
      TimeRangeAppExt.mainpanel=new Ext.Panel({
		id:PanelId,
		title:" ",
		autoWidth:true,
		width:"auto",
		frame:true,
    	renderTo:"ExtApp",
    	collapsible:true,
    	hidden:true
	})
}
Ext.onReady(init);