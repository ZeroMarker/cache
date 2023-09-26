
/*提示数组*/
t["Seccess"] = "保存成功";

/*提示数组*/
var Grid;
var CM;
var SM;
var store;

//获取列索引　通过列名
function getColIndexByName(ColumnName) {
    var cm = Ext.getCmp("LocList").getColumnModel();
    var column = cm.getColumnById(ColumnName);
    return cm.columns.indexOf(column);
}
function SetLinkRender(value) { 

var url = "<a href='#' target='_self' value='"+value+"' onclick='OpenMinorLocList(this)'>二级科室</a>"; 
return url; 
} 

function OpenMinorLocList(obj){
	var LocRowid="";
	if (!obj.value) {
		LocRowid=obj.getAttribute("value");
	}else{
		LocRowid=obj.value;
	}
	
  var url="minor.ctloclist.update.csp?ID="+LocRowid;
  //window.showModalDialog(url, "", "dialogwidth:30em;dialogheight:25em;center:1"); 
  window.open(url);
  return websys_cancel();
}
function GetRow() {
    var sm=SM;
    if ((sm) && (sm.getSelectedCell())) {
        return sm.getSelectedCell()[0];
    } else {
        return -1 ;//GRID.getStore().getCount() - 1;
    }
}
Ext.onReady(function() {	
    Ext.ux.DateField=Ext.extend(Ext.form.DateField,{
		//anchor : '100%',
	//	width : 80,
		format: SYSDateFormat,
		invalidClass:'',
		invalidText:'',
		regexText:'请输入正确的日期格式!',
		initComponent:function(){
			var altFormats = 'j|d|md|ymd|Ymd'+'|Y-m|Y-n|y-m|y-n'+'|Y-m-d|Y-m-j|Y-n-d|Y-n-j|y-m-d|y-m-j|y-n-d|y-n-j';
			var regex = /^(t|(t[\+\-]\d*)|\d{1,2}|\d{4}|\d{6}|\d{8}|((\d{4}|\d{2})\-\d{1,2}\-\d{1,2}))$/;
			if(SYSDateFormat == 'm/d/Y'){
				altFormats = 'j|d|md|mdy|mdY'+'|n/j|n/d|m/j|m/d'+'|n/j/y|n/j/Y|n/d/y|n/d/Y|m/j/y|m/j/Y|m/d/y|m/d/Y';
				regex = /^(t|(t[\+\-]\d*)|\d{1,2}|\d{4}|\d{6}|\d{8}|(\d{1,2}\/\d{1,2}\/(\d{4}|\d{2})))$/;
			}else if(SYSDateFormat == 'd/m/Y'){
				altFormats = 'j|d|dm|dmy|dmY'+'|j/n|j/m|d/n|d/m'+'|j/n/y|j/n/Y|j/m/y|j/m/Y|d/n/y|d/n/Y|d/m/y|d/m/Y';
				regex = /^(t|(t[\+\-]\d*)|\d{1,2}|\d{4}|\d{6}|\d{8}|(\d{1,2}\/\d{1,2}\/(\d{4}|\d{2})))$/;
			}
			this.altFormats = altFormats;
			this.regex = regex;
			this.on('blur',function(e){
				var str=this.getRawValue();
				str=str.replace(/\s/g,"").toLowerCase();
				if(str=="t"){
					this.setValue(new Date());
				}
				else if(str.indexOf("t+")==0 || str.indexOf("t-")==0){
					var addDayNum=parseInt(str.substring(2));
					if(isNaN(addDayNum)){
						this.setValue('');
					}else{
						if(addDayNum=="") {addDayNum=0;}
						if(str.substring(1,2)=="-"){
							addDayNum=-addDayNum;
						}
						this.setValue(new Date().add(Date.DAY, parseInt(addDayNum)));
					}
				}else{
					this.setValue(this.getValue());
				}
			});
			this.on('specialkey',function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					this.fireEvent('blur');
				}
			});
			Ext.ux.DateField.superclass.initComponent.call(this);
		},
		/*
		 * 重写DateField的parseDate方法,对于6位数字格式化进行特殊处理
		 */
		parseDate : function(value) {
			if(!value || Ext.isDate(value)){
				return value;
			}
			var v = this.safeParse(value, this.format),
				af = this.altFormats,
				afa = this.altFormatsArray;
			if (!v && af) {
				afa = afa || af.split("|");
				for (var i = 0, len = afa.length; i < len && !v; i++) {
					if(afa[i] == 'ymd' && Ext.isString(value) && (Number(value) == value) && value.length == 6 && value.substring(2,4) > 12){
						//该if内为特殊处理部分, 形如201609(第3,4为>12)取该月最后一天,即20160930
						var firstDay = Date.parseDate(value + '01', 'Ymd');
						v = firstDay.getLastDateOfMonth();
					}else{
						v = this.safeParse(value, afa[i]);
					}
				}
			}
			return v;
		}
	});
	Ext.reg('uxdatefield',Ext.ux.DateField);
	debugger;
    var columnHeaders = ["科室", "代码","开始日期", "截止日期","二级科室"];
    var dataIndexs = ["Code", "Name", "StartDate", "EndDate","RowID"];
    
    var columns = new Array();
    var dataRecords = new Array();
	
    for (var j = 0; j < dataIndexs.length; j++) {
        switch (columnHeaders[j]) {
			case "开始日期":
				columns.push({
					header:columnHeaders[j],
					id: dataIndexs[j],
					dataIndex: dataIndexs[j],
					width: 150,
					format: SYSDateFormat,
					renderer: function(value) {
						if (value) {
							if ((!Ext.isDate(value)) && (value.toString().indexOf("/") == -1)&& (value.toString().indexOf("-") == -1)) {
								var ret = cspRunServerMethod(GetHTMLDate, value);
								return ret;
							}
							if (Ext.isDate(value)) {
								value = value.format(SYSDateFormat);
								return value;
							}
						}
						
						return value;
					},
					//DateField format default=:'m/d/y'
					editor: new Ext.ux.DateField({ //Ext.form.DateField({
						format: SYSDateFormat
					}) //})

				});
				break;
			case "截止日期":
				columns.push({
					header:columnHeaders[j],
					id: dataIndexs[j],
					dataIndex: dataIndexs[j],
					width: 150,
					format: SYSDateFormat,
					renderer: function(value) {
						
						if (value) {
							if ((!Ext.isDate(value)) && (value.toString().indexOf("/") == -1)&& (value.toString().indexOf("-") == -1)) {
							 
								var ret = cspRunServerMethod(GetHTMLDate, value);
								return ret;
							}
							if (Ext.isDate(value)) {
								value = value.format(SYSDateFormat);
								return value;
							}
						}
						return value;
						
					},
					//DateField format default=:'m/d/y'
					editor: new Ext.ux.DateField({ //Ext.form.DateField({
						format: SYSDateFormat
					}) //})

				});
				break;
		
		   case "二级科室":
				columns.push({
					header:columnHeaders[j],
					id: dataIndexs[j],
					dataIndex: dataIndexs[j],
					width: 150,
					renderer: SetLinkRender
				})
				break;
			default:
				columns.push({
					header:
					columnHeaders[j],
					id: dataIndexs[j],
					dataIndex: dataIndexs[j],
					width: 200,
					editable: true,
					editor: new Ext.form.TextField({ 
					// allowBlank: false
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
        columns: columns,
        isCellEditable: function(col, row) {
            var record = store.getAt(row);
            var rowOfView = Ext.getCmp("LocList").getView().getRow(row); 
            if (Ext.isDefined(rowOfView) && (Ext.isDefined(rowOfView.isEditable))) {
                return false;
            }
	
            return Ext.grid.ColumnModel.prototype.isCellEditable.call(this, col, row);
        }
    });
    store = new Ext.data.Store({
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
			  var totalCount=store.getCount();
			  var Loc=new Object();
			  Loc.Code="";
			  Loc.Name="";
			  Loc.StartDate="";
			  Loc.EndDate="";
			  Loc.RowID="";
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
			  if(UpdatetMajor){
				  if(modified.length==0){
					  alert("没有需要保存的记录")
					  return false;
				  }
				  for(var i=0;i<modified.length;i++){
					 var json=modified[i].json;
					 var data=modified[i].data;
					 var modifiedFields=modified[i].modified;
					 var StartDate =Ext.isDate(data.StartDate)?data.StartDate.format(SYSDateFormat):"";
					 var EndDate=Ext.isDate(data.EndDate)?data.EndDate.format(SYSDateFormat):"";
					 if (StartDate==""){StartDate=data.StartDate}
					 if (EndDate==""){EndDate=data.EndDate}
					 if (data.Code=="") {
					 	alert("请填写科室名称");
					 	return false;
					 }
					 if (data.Name=="") {
						alert("请填写科室代码");
					 	return false;
					 }
					 //update
					 if(json){
						
						var ret=cspRunServerMethod(UpdatetMajor,data.RowID,data.Code,data.Name,StartDate,EndDate);
						if(ret==1){
							//alert("保存成功");
						}
						else{
							alert(data.Name+"保存失败");
							return;
						}
					 }
					 //insert
					 if(data.RowID==""){
					   
					    var ret=cspRunServerMethod(InsertMajor,data.Code,data.Name,StartDate,EndDate);
						if(ret==1){
							//alert("保存成功");
						}
						else{
							alert(data.Name+"保存失败");
							return;
						}
					 }
					
				  }
			  }
			  //store.load();
			  alert("保存成功");
			  store.commitChanges();
			  window.location.reload();
			}
          
        },
		{
            text: '删除',            
            id: 'DeleteLoc',
            iconCls:'icon-delete-custom',
			handler:function(obj){
			  var store=GRID.getStore();
			  var row=GetRow();
			  if (row=="-1"){alert("请选择有效的记录");return}
			  if(store.getAt(row)){
				  var RowID=store.getAt(row).get("RowID");	
                  if(RowID!=""){				  
					  var vaild = window.confirm("您确定要删除吗？");
						if(!vaild) {				
						return;
						
						}
					  var ret=cspRunServerMethod(DeleteMajor,RowID);
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
					//store.commitChanges();
				}
				
			  }
			}
        }
        ]
    });
    
	var sm=new Ext.grid.CellSelectionModel();	
    var LocList = new Ext.grid.EditorGridPanel({
        id: "LocList",
        store: store,
        cm: cm,
		sm:sm,
		region: "center",
        height: '380',
		width:'1300',       
		autoScroll:true,
        frame: true,
        clicksToEdit: 1,
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
        title: "科室列表维护",
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
            pClassName: "web.DHCCTLocMajor",
            pClassQuery: "GetMajorLocList"
        },
        callback: function(r, options, success) {
            var count=store.getCount();
			if(count-1>0){
				if(store.getAt(count-1)){
			       var rowid=store.getAt(count-1).get("RowID");
				   if(rowid=="")
				   store.removeAt(count-1);
				}
			}
			
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
