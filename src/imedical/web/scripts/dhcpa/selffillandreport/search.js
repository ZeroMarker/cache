//=====================function================================================//
//点击最后一个条件触发事件
function search(){
	 year = yearField.getRawValue();		
	 frequency=periodTypeField.getValue();		
	 acuttypeitem = periodField.getValue();		
	 deptDr = deptField.getValue();	
	 DschemDr = DeptSchemField.getValue();	
	var urlStr = '../csp/dhc.pa.selffillandreportexe.csp?action=listHNew'+ "&year=" + year + "&frequency=" + frequency + "&acuttypeitem=" + acuttypeitem + "&userId=" + userId + "&deptDr=" + deptDr + "&DschemDr=" + DschemDr ;
	Ext.Ajax.request({
		url : urlStr,
		success : function(response, opts) {
			var obj = Ext.decode(response.responseText);
			getColumnObj(obj.checks);
		},
		failure : function(response, opts) {
			console.log('server-side failure with status code '	+ response.status);
		}
			
	});	
}

//动态列函数
function getColumnObj(schemNum){
	var columnArry =[
		new Ext.grid.RowNumberer(),sm,
		{header:'YRowid',dataIndex:'YRowid',hidden:true},
		{header:'项目名称',width:200,dataIndex:'schemLevel_0',id:'schemLevel_0'}
	];
					
	var fieldArry=[
		{name: 'YRowid',mapping:'YRowid'},
		{name: 'schemLevel_0',mapping:'schemLevel_0'}
	];
	
	for(var i=1;i<=schemNum;i++){
		var schemName ="schemLevel_"+i;
		var headName=i+"级项目"
		columnArry.push({header:headName,dataIndex:schemName,width:200,id:schemName,
							renderer:function(value,meta,record){
							    meta.attr = 'style="white-space:normal;padding:5px;"'; 
								return value; 
							}
		});
		fieldArry.push({name: schemName,mapping:schemName});
	}
	columnArry.push({ header: '填报内容',dataIndex: 'URDContent', width:300,height:50,id: 'URDContent', 
						editor: new fm.TextArea({
							allowBlank: false
						}),renderer:function(value,meta,record){
							meta.attr = 'style="white-space:normal;line-height: 15px;"'; 
							return value; 
						}
					}, {header: '提交状态',dataIndex: 'UDRsubmitState', width: 70,  align: 'center',id:'UDRsubmitState',
						renderer:function(value,meta,record){
							
							if(value==1){
								$("table[id=sumBtn]").addClass("x-item-disabled");
								$("table[id=sumBtn] button").attr("disabled","disabled");
								$("table[id=uploadBtn]").addClass("x-item-disabled");
								$("table[id=uploadBtn] button").attr("disabled","disabled");
								
								return "已提交";
							}else{
								$("table[id=sumBtn]").removeClass("x-item-disabled");
								$("table[id=sumBtn] button").removeAttr("disabled");
								$("table[id=uploadBtn]").removeClass("x-item-disabled");
								$("table[id=uploadBtn] button").removeAttr("disabled");
								return '<span style="color:blue;">未提交</span>' ;
							}
						}
					});
	fieldArry.push({name: 'URDContent', mapping: 'URDContent'},					
				   {name: 'UDRsubmitState',mapping:'UDRsubmitState'});
					
	var fieldsStr = Ext.data.Record.create(fieldArry);
	var editStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:'../csp/dhc.pa.selffillandreportexe.csp?action=listHNew'+ "&year=" + year + "&frequency=" + frequency + "&acuttypeitem=" + acuttypeitem + "&userId=" + userId + "&deptDr=" + deptDr + "&DschemDr=" + DschemDr }),
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
			},fieldsStr),
		remoteSort: true
	}); 
	var editCm = new Ext.grid.ColumnModel({
		defaults: {
			sortable: true          
		},
		columns: columnArry
	});
	
	editGrid.reconfigure(editStore, editCm);
	
	editStore.load({params:{year:year,frequency:frequency,acuttypeitem:acuttypeitem,deptDr:deptDr,DschemDr:DschemDr,userId:userId}});		
	editStore.on('load',function(){
		rowspanFun(editGrid,schemNum);
		var isSubmit=$("table[id=sumBtn] button").attr("disabled");
		var isupload=$("table[id=uploadBtn] button").attr("disabled");
		if(isSubmit=="disabled"){
			$("td.x-grid3-col.x-grid3-cell.x-grid3-td-URDContent").removeClass("x-grid3-td-URDContent");
		}
		if(isupload=="disabled"){
			$("td.x-grid3-col.x-grid3-cell.x-grid3-td-URDContent").removeClass("x-grid3-td-URDContent");
		}
		
	});
	
}