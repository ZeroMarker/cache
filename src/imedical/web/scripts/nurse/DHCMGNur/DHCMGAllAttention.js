/**
 * @author Qse
 */
var col=new Array();
var dataset=new Array();
var datafield=new Array();

cspRunServerMethod(GetHead,"GetColmHead",AttTyp);
var colM=new Ext.grid.ColumnModel(col);
function GetColmHead(a1,a2,a3,a4,a5)
{
	if (col.length == 0) {
		col.push(new Ext.grid.RowNumberer());
	}
	col.push({
		header: a1,
		dataIndex: a2,
		width:parseInt(a3),
		hidden:Boolean(a4),
		align: a5, 
		sortable: true
	}
	)
	datafield.push(a2);
}
var attenitm=new Array();
//cspRunServerMethod(getattentionData,AttTyp,WardTree,"add");
add("allattention","住院关注项目总计");

function add(a1, a2){
	attenitm.push({
		xtype:'panel',
		id: a1,
		title: a2,
		region:'center',
		height:1000,
		layout:'fit',
		closable:false,
		items:[getgriddata(a1)]
	})
}

var subttab=new Ext.TabPanel({
	activeTab : 0,//
   	autoTabs: true,
   	//resizeTabs:true,
   	height:615,
   	width:800,
   	enableTabScroll:true,
	autoScroll:true,
   	items:attenitm
});

Ext.onReady(function(){ 
new Ext.Viewport({
	enableTabScroll:true,
	items:subttab
})
subttab.setActiveTab(3);
});

function adddata(a){
	dataset.push(a)
}

function getgriddata(itmid){
 	dataset=new Array();
 	cspRunServerMethod(getAttenionDetail,AttTyp,"adddata");
	dataset="["+dataset+"]";
	var json = Ext.util.JSON.decode(dataset);
	var store=new Ext.data.JsonStore({data:json,fields:datafield});
	
	var grid = new Ext.grid.GridPanel({
  		title:"",
  		height:200,
  		width:600, 
		stripeRows:true,//斑马线效果
		loadMask:true,//显示"Loading..."
 		cm:colM,
		sm: new Ext.grid.CellSelectionModel(),
 		store:store,
 		//autoExpandColumn:0,
		autoScroll:true,
 		autoSizeColumns : true,//根据列内容自动适应列宽度
 		Frame:false,
  		border : true,// 出现边框
 		viewConfig:{ 
			forceFit:true //下拉滚动条是否使用
		}
	}); 

	grid.on("cellclick",function(grid, rowIndex, columnIndex, e) {
        //alert(rowIndex+" "+columnIndex)
		var recordtoedit = grid.getStore().getAt(rowIndex);  // Get the Record
		var fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
		var data = recordtoedit.get(fieldName);
		var wardid=recordtoedit.get("WardId");
		var ward=recordtoedit.get("Ward");
        //Ext.Msg.alert('查看选中', "您现在选中的病区ID为:" + recordtoedit.get("WardId")+"<br>列为: "+fieldName);
    	if(wardid=="") return;
		var url;
		if (fieldName=="Ward") {
			url = "../csp/dhcmgwardpatlist.csp?Ward=" + wardid + "&AttTyp=A^O";
		}
		else {
			if (fieldName == "WardId") {
				return;
			}
			else{
				url = "../csp/dhcmgwardattention.csp?Ward=" + wardid + "&AttTyp=A^O"+"&AttItem="+fieldName;
			}
		}
		var win = new Ext.Window({
   			title : ward,
   			maximizable : true,
   			//maximized : true,
   			width : 750,
   			height : 600,
   			autoScroll : true,
   			//bodyBorder : true
   			//draggable : true,
   			isTopContainer : true,
   			modal : true,
   			resizable : false,
			constrainHeader : true,
   			contentEl : Ext.DomHelper.append(document.body, {
    			tag : 'iframe',
    			style : "border 0px none;scrollbar:true",
    			src : url,
    			height : "100%",
    			width : "100%"
   			})
  		})
  		win.show(); 
	},this)
	//grid.addListener('rowcontextmenu', rightClickFn);
	//grid.addListener('rowclick', rowClickFn);
	//grid.addListener('rowdblclick', rowClickFn);
	return grid;
}

   

  