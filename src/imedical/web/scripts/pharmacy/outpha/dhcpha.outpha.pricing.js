//dhcpha.outpha.pricing.js


$(function(){
	InitThisLocInci(session['LOGON.CTLOCID']);
	InitDrugTitle();
	$("#btn-add").on("click",AddDrugRow);
	$("#btn-clear").on("click",ClearConditions);
	$("#btn-del").on("click",DelRow)
	$('#txt-qty').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			AddDrugRow();	
		}
	});
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
})
 //初始化药品选择
function InitThisLocInci(locrowid){
	var locincioptions={
		id:"#sel-locinci",
		locid:locrowid,
		width:'21.7em'
	}
	InitLocInci(locincioptions)
}
//初始化发药查询列表
function InitDrugTitle(){
	//定义columns
	var columns=[
        {header:("药品Id"),name:'Inci',index:'Inci',width:120,hidden:true,title:false},
        {header:("药品代码"),name:'InciCode',index:'InciCode',width:100,align:'left',title:false},
        {header:("药品名称"),name:'InciDesc',index:'InciDesc',width:200,align:'center',title:false}, 
        {header:("数量"),name:'Qty',index:'Qty',width:80,editable:true,align:'center',title:false,
        	editoptions:{
	        	size:10,
	        	dataEvents: [{
					type: 'keydown',  //blur,focus,change.............
					fn: function(e) {
						if(e.keyCode="13"){
							var QtyId = $(event.target)[0].id;
							var rowid=QtyId.replace("_Qty","")
					    	var Qty=$('#'+QtyId).val();
					    	$('#'+QtyId).val(Qty).css("color","#000");
							var rowData = $("#gird-druginfo").jqGrid("getRowData",rowid);
					    	var Sprice=rowData.Sprice;
					    	Sprice=parseFloat(Sprice);
					    	var SpAmt=Sprice*Qty;
					    	$("#gird-druginfo").jqGrid("setCell",rowid,7,SpAmt);
					    	CalTotalAmt();
						}
					}
	        	},{
					type: 'change',  //blur,focus,change.............
					fn: function(e) {
							var QtyId = $(event.target)[0].id;
							var rowid=QtyId.replace("_Qty","")
					    	var Qty=$('#'+QtyId).val();
					    	$('#'+QtyId).val(Qty).css("color","#000");
							var rowData = $("#gird-druginfo").jqGrid("getRowData",rowid);
					    	var Sprice=rowData.Sprice;
					    	Sprice=parseFloat(Sprice);
					    	var SpAmt=Sprice*Qty;
					    	$("#gird-druginfo").jqGrid("setCell",rowid,7,SpAmt);
					    	CalTotalAmt();
					}
	        	}]
        	}
        },
        {header:("单位"),name:'Uom',index:'Uom',width:120,algin:'center',title:false},
        {header:("规格"),name:'Spec',index:'Spec',width:120,align:'center',title:false},
        {header:("售价"),name:'Sprice',index:'Sprice',width:80,align:'right',title:false},
        {header:("售价金额"),name:'SpAmt',index:'SpAmt',width:90,align:'center',title:false}, 
        {header:("生产企业"),name:'ManfDesc',index:'ManfDesc',align:'center',title:false}, 
        {header:("医保类型"),name:'Insurance',index:'Insurance',width:80,hidden:true,title:false}
  	];    
         
    var jqOptions={
	    url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
	    colModel: columns, //列
	    height: DhcphaJqGridHeight(1,1),    
	    autowidth:true,
	    multiselect: false,
	    shrinkToFit:false,
	    //cellsubmit:"clientArray",
	    //cellEdit:true,
	    datatype: 'local',
	    loadComplete: function(){
	    }
	     	    
	} 
   //定义datagrid	
   $('#gird-druginfo').dhcphaJqGrid(jqOptions);
}
function AddDrugRow(){
	var inciRowId=$("#sel-locinci").val();
	if (inciRowId==null){
		inciRowId="";
	}
	if(inciRowId==""){return;}
	
	var retval=tkMakeServerCall("PHA.OP.Pricing.Query","GetDrugInfo",inciRowId,session['LOGON.CTLOCID']);
	if(retval==""){return}
	var ArrInfo=retval.split("^");
	var InciCode=ArrInfo[0];
	var InciDesc=ArrInfo[1];
	var Rp=ArrInfo[2];
	var Sp=ArrInfo[3];
	var Qty=$("#txt-qty").val();
	if(Qty==null){Qty=0}
	var Uom=ArrInfo[4];
	var SpAmt=Sp*Qty;
	var RpAmt=Rp*Qty;
	var Inci=ArrInfo[5];
	var Spec=ArrInfo[6];
	var ManfDesc=ArrInfo[7];
	var Insurance=ArrInfo[8];
	
	var rowDatas = $("#gird-druginfo").jqGrid("getRowData");
	var ids = rowDatas.length;
	if(ids==0){
		var dataRow={Inci:'',InciCode:'',InciDesc:$g("合计"),Qty:'',Uom:'',Spec:'',Sprice:'',SpAmt:'',ManfDesc:'',Insurance:''}
		$("#gird-druginfo").jqGrid("addRowData", ids, dataRow, "last");

	}
	var newid=ids+1;
	var dataRow={Inci:Inci,InciCode:InciCode,InciDesc:InciDesc,Qty:Qty,Uom:Uom,Spec:Spec,Sprice:Sp,SpAmt:SpAmt,ManfDesc:ManfDesc,Insurance:Insurance}
	$("#gird-druginfo").jqGrid("addRowData", newid, dataRow, "last");
	$("#gird-druginfo").jqGrid('editRow',newid);
	CalTotalAmt();
	$('#sel-locinci').focus();
	return false;
	
}
function CalTotalAmt()
{
	var rowDatas = $("#gird-druginfo").jqGrid("getRowData");
	var idnum = rowDatas.length;
	var Amt=0;
	for(var i=1;i<idnum;i++){
		var rowdata=rowDatas[i]
		var SpAmtnum=rowdata.SpAmt;
		SpAmtnum=parseFloat(SpAmtnum);
		var Amt=Amt+SpAmtnum;
	}
	$("#gird-druginfo").jqGrid("setCell",0,7,Amt);	

}
function ClearConditions() {
	
	$("#sel-locinci").empty();
	$("#txt-qty").val("");
	$("#gird-druginfo").clearJqGrid();
}
function DelRow()
{
	
	var selectedId=$("#gird-druginfo").jqGrid("getGridParam","selrow");  
	if((selectedId==null)||(selectedId=="0")){return;} 
 	//var rowData=jQuery("#gird-druginfo").jqGrid("getRowData",rowid);
 	$("#gird-druginfo").jqGrid('delRowData', selectedId);
 	CalTotalAmt();
}
