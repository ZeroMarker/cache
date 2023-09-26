
/*提示数组*/

/*提示数组*/
var Grid;
var CM;
var SM;
var LocStore;
var LocListRecord;
//获取列索引　通过列名
function getColIndexByName(ColumnName) {
    var cm = Ext.getCmp("LocList").getColumnModel();
    var column = cm.getColumnById(ColumnName);
    return cm.columns.indexOf(column);
}
function SetLinkRender(value) { 
	var url = "<a href=\"minor.ctloclist.update.csp?ID="+value+"\" target='_blank'>二级科室</a>"; 
	return url; 
} 
function GetRow() {
    var sm=SM;
    if ((sm) && (sm.getSelectedCell())) {
        return sm.getSelectedCell()[0];
    } else {
        return GRID.getStore().getCount() - 1;
    }
}
function LocChangeHandler(obj,value,text){  
  var store = GRID.getStore();
	for(var i=0;i<LocListRecord.length;i++){
	     if(LocListRecord[i].CTLocDesc==value){
		 store.getAt(GetRow()).set("CTLocDR", LocListRecord[i].CTLocID);
		 break;
		 }
	}
}
function LocselectHandler(obj,Selobj,text) {
	var store = GRID.getStore();
	for(var i=0;i<LocListRecord.length;i++){
		
	   if(LocListRecord[i].CTLocDesc==Selobj.id){
	   	var Hospital=cspRunServerMethod(GetHospitalByLocDesc,Selobj.id.split(" ")[1])
		 	store.getAt(GetRow()).set("Hospital", Hospital);
		 	 store.getAt(GetRow()).set("CTLocDR", LocListRecord[i].CTLocID);
		 	break;
		 }
	}
}
function SetComboBoxRender(value, obj) { 
    if (this.editor.el) {
        var rawValue = this.editor.getValue();   
		
        return rawValue;          
    }else {
   
        return value;
    }
}

function AjaxState_Change(xmlhttp)
{


}

function getLocList(desc){

   if (window.XMLHttpRequest) {
       var xmlhttp = new XMLHttpRequest(); 
        
        if (xmlhttp) {
			var url="ext.websys.querydatatrans.csp?pClassName=web.DHCCTLocMinor&pClassQuery=GetOPLocList&P1="+desc;
			
            xmlhttp.onreadystatechange = AjaxState_Change.createCallback(xmlhttp); 
            xmlhttp.open('GET', url,false);
            xmlhttp.send(null);
			if ((xmlhttp.readyState == 4) && (xmlhttp.status == 200))  {
				  
					var result = xmlhttp.responseText;
					var error = "";
					try {
						result = eval("(" + result + ')');
					} catch(e) {
						error = 0;
						window.console && console.warn("XMLHttpRequest" + result);
					}
					if (error === 0) {
						result = 0;
						return;
					}
				
					LocStore=new Array();
					var count=result.record.length;
					 LocListRecord=result.record;
					for(var i=0;i<count;i++){
						//LocStore.push([LocListRecord[i].Description,LocListRecord[i].Description]);
						LocStore.push([LocListRecord[i].CTLocDesc,LocListRecord[i].CTLocDesc]);
					}
					//return LocStore;
			}
        }
    };
}
Ext.onReady(function() {
	
	
 
	getLocList("");
	var checkColumn = new Ext.grid.CheckColumn({
        header: '激活标志',
        dataIndex: 'IsActive',
        id: "IsActive",
        width: 55,
		 render: function(value) {
            return value == "1" ? true: false;
        }	
       
    });
    var columnHeaders = ["科室","激活标志","医院"];
    var dataIndexs = ["CTLocDesc", "IsActive","Hospital","RowID","CTLocDR"];    
    var columns = new Array();
    var dataRecords = new Array();	
    for (var j = 0; j < dataIndexs.length; j++) {
        switch (columnHeaders[j]) {
			case "科室":
				columns.push({
					header:columnHeaders[j],
					id: dataIndexs[j],
					dataIndex: dataIndexs[j],
					width: 250,
				    editor: new Ext.form.ComboBox({
							width: 80,
							typeAhead: true,
							//forceAll: true,
							//forceSelection: true,
							triggerAction: 'all',
							mode: 'local',
							dataIndex: dataIndexs[j],
							lazyRender: true,
													
							store: new Ext.data.ArrayStore({
								autoDestroy: true,
								'id': 0,
								fields: ['value', 'text'],
								data:LocStore
							
							}),
							valueField: 'value',
							displayField: 'text',

							listeners: { 
								change: LocChangeHandler,
								select: LocselectHandler		
							}
					})

				});
				break;
			case "激活标志":
				columns.push(checkColumn);
				break;				
			case "医院":
					columns.push({
					header:columnHeaders[j],
					id: columnHeaders[j],
					dataIndex: dataIndexs[j],
					width: 200
					/*
					editor: new Ext.form.TextField({ 
					
					})
					*/
				})
				break;			
			default:
				columns.push({
					header:"",
					id: dataIndexs[j],
					dataIndex: dataIndexs[j],
					width: 200,
					hidden:true, 
					editor: new Ext.form.TextField({ 
					
					})
				});
 
        }
    }
    for (var i = 0; i < dataIndexs.length; i++) {
        dataRecords.push({
            name: dataIndexs[i],
            type: "string"
        });
    }
    var cm = new Ext.grid.ColumnModel({
        defaults: {
            sortable: false // columns are not sortable by default           
        },
        columns: columns
    });
    var store = new Ext.data.Store({
        autoDestroy: true,
        url: "ext.websys.querydatatrans.csp",
        reader: new Ext.data.JsonReader({
            totalProperty: 'total',
            root: 'record'
        },
        Ext.data.Record.create(dataRecords)) //,sortInfo: {field:'common', direction:'ASC'}
        ,
        listeners: {
            add: function(ds, records, options) {}
        }
    });


    var tbar = new Ext.Toolbar({
        items: [
		{
            text: '新建',            
            id: 'CreateLoc',
            iconCls: 'icon-add-custom',
			handler:function(obj){
			  var store=GRID.getStore();
			  var recordType = store.recordType;
			  var Loc=new Object();			  
			  Loc.CTLOCDesc="";
			  Loc.IsActive="";
			  Loc.RowID="";
			  Loc.CTLocDR="";
			  var totalCount=store.getCount();
			  var p=new recordType(Loc);
			   store.insert(totalCount,p);	
			   GRID.startEditing(totalCount,0)
			}
        },
		{
            text: '保存',
			id:'SaveLoc',
			iconCls:'icon-filesave-custom',
			handler:function(obj){
			  var store=GRID.getStore();
			  var modified=store.getModifiedRecords();
			  if(UpdateMinor){
				  if(modified.length==0){
					  alert("没有需要保存的记录")
					  return false;
				  }
				  for(var i=0;i<modified.length;i++){
					 var json=modified[i].json;
					 var data=modified[i].data;
					 var modifiedFields=modified[i].modified;
					
					 //update
					 if(json){
						
						var ret=cspRunServerMethod(UpdateMinor,data.RowID,ParRef,data.CTLocDR,data.IsActive);
						if(ret==1){
							//alert("保存成功");
						}
						else{
							alert(data.CTLocDesc+"保存失败"+ret);
							return;
						}
					 }
					 //insert
					 if(data.RowID==""){
					    var ret=cspRunServerMethod(InsertMinor,ParRef,data.CTLocDR,data.IsActive);
						if(ret==1){
							//alert("保存成功");
						}
						else{
							alert(data.CTLocDesc+"插入失败"+ret);
							return;
						}
					 }
					
				  }
			  }
			  //store.load();
			  store.commitChanges();
			  alert("保存成功");
			   store.load({
					params: {
						pClassName: "web.DHCCTLocMinor",
						pClassQuery: "GetMinorList",
						P1:ParRef
					},
					callback: function(r, options, success) {

					}
		       });
			 // window.close();
			}
          
        },
		{
            text: '删除',            
            id: 'DeleteLoc',
            iconCls:'icon-delete-custom',
			handler:function(obj){
			  var store=GRID.getStore();
			  var model = GRID.getSelectionModel();
			  if(!model.hasSelection()){
				  alert("请选择需要删除的记录")
				  return false;
			  }
			  var row=GetRow();
			  if(store.getAt(row)){
			  var RowID=store.getAt(row).get("RowID");
                 if(RowID!=""){			  
				  var vaild = window.confirm("您确定要删除吗？");
					if(!vaild) {				
					return;
					
					}
					
				  var ret=cspRunServerMethod(DeleteMinor,ParRef+"||"+RowID);
				  if(ret==1){
					alert("删除成功")
					store.removeAt(row);
					//store.commitChanges();
				  }
				  else{
					alert("删除失败")
				  }
				}else{
					store.removeAt(row);
					store.commitChanges();				
				}
			  }
			}
        }]
    });
    
	var sm=new Ext.grid.CellSelectionModel();
	

    var LocList = new Ext.grid.EditorGridPanel({
        id: "LocList",
        store: store,
        cm: cm,
		sm:sm,
		plugins:checkColumn,
		//隐藏标题
        //header: false,
        region: "center",
        //plain: true,
        //使用固定高度
        height: '380',
		width:'1300',       
		autoScroll:true,
        frame: true,
        clicksToEdit: 1,
        //layout:'fit',
        //collapsed:true,
        //collapsible: true,
        enableDragDrop: false,
        enableHdMenu: false,
        //重写initEvents 防止滚动鼠标时 停止编辑
        initEvents: function() {
            Ext.grid.EditorGridPanel.superclass.initEvents.call(this); //this.getGridEl().on('mousewheel', this.stopEditing.createDelegate(this, [true]), this);
            this.on('columnresize', this.stopEditing, this, [true]);
            if (this.clicksToEdit == 1) {
                this.on("cellclick", this.onCellDblClick, this);
            } else {
                var view = this.getView();
                if (this.clicksToEdit == 'auto' && view.mainBody) {
                    view.mainBody.on('mousedown', this.onAutoEditClick, this);
                }
                this.on('celldblclick', this.onCellDblClick, this);
            }
        },
        tbar:tbar,
        title: "二级科室列表维护",
        listeners: {
            resize: function(a, b, c) {},
            render: function() {

            },
            bodyresize: function(a, b, c) {},
            afteredit: function(obj) {

            }
        }
    });
    store.load({
        params: {
            pClassName: "web.DHCCTLocMinor",
            pClassQuery: "GetMinorList",
			P1:ParRef
        },
        callback: function(r, options, success) {

        }
    });

   

    var viewport = new Ext.Viewport({
        layout: 'border',
        id: "viewport",
        items: [LocList]
    });
   GRID=LocList;
   SM=sm;
   CM=cm;
	
	

}); //End Of Ext.onready
