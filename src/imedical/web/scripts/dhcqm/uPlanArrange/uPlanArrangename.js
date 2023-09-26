function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}


Name = function(dataStore,grid,pagingTool,addOrEdit,periodtxt,yearPeriod,userDr,planId) {

	//得到已经选择的项目id
	if(addOrEdit=="edit"){
		var rowObj=grid.getSelectionModel().getSelections();
		var deptGroupDr=rowObj[0].data.deptGroupDr;
		var userDr=rowObj[0].data.checkUser;
	}else{
		var deptGroupDr="";
	}
	//将获取的数据，科室和病区单独分出来
	var deptStr="",wardStr="";
	var deptGroupArr=deptGroupDr.split(",");
	for(var i=0,deptLen=deptGroupArr.length;i<deptLen;i++){
		var deptGroup=deptGroupArr[i];
		var deptWard=deptGroup.split("||");
		var dept=deptWard[1];
		
		deptStr=deptStr+","+dept;
	
	}
	//定义勾选的数组
	var selectDeptArr=[];	//科室
	var selectWardArr=[];  //病区
		
	var nameUrl = '../csp/dhc.qm.uPlanArrangeexe.csp';
	var nameProxy= new Ext.data.HttpProxy({url:nameUrl + '?action=nameList'+'&periodTxt='+encodeURIComponent(periodtxt)+"&yearPeriod="+yearPeriod+"&userDr="+userDr+"&RowId="+planId,method:'POST'});
	var nameDs = new Ext.data.Store({   //解析数据源
			proxy: nameProxy,
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'	
			},['rowid','deptGroupCode','deptGroupName']),
			remoteSort: true	
	});
	var depsm = new Ext.grid.CheckboxSelectionModel();
	//设置默认排序字段和排序方向
	nameDs.setDefaultSort('rowid', 'deptGroupName');
	//数据库数据模型
	var nameCm = new Ext.grid.ColumnModel([
		depsm,
		new Ext.grid.RowNumberer(),
		{
			id:'rowid',
			header: '检查科室ID',
			allowBlank: false,
			width:200,
			editable:false,
			dataIndex: 'rowid',
			hidden:true
	   },{

			id:'deptGroupName',
			header: '检查科室',
			allowBlank: false,
			width:200,
			editable:false,
			dataIndex: 'deptGroupName' ,
			renderer: function(value, metaData, record, rowIndex, colIndex, store){
			   var deptRowid=record.data.rowid;
			   var isExt=deptStr.indexOf(deptRowid);
			   if(isExt>-1){
					selectDeptArr.push(rowIndex);
					metaData.css="oldSelectColor";	//2016-8-4 add cyl
			   }
				return value;
			}
	   }
	]);

	var grid = new Ext.grid.GridPanel({
		id:'dept',
		region: 'west',
		store:nameDs,
		width: 280,
		cm:nameCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:depsm,
		loadMask: true
	});
	

	//----------------------------------------------------------------------------------------------------
	var peUrl = '../csp/dhc.qm.uPlanArrangeexe.csp';
	var peProxy;
	var recordIds=new Array();//
	//外部指标
	var peDs = new Ext.data.Store({
		proxy: peProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
			'rowid',
			'wardName'
		]),
		remoteSort: true,  
        listeners : {  
            load : function() {  
                var records = new Array();  
                peDs.each(function(record) { 
	                 var wardRowid=record.data.rowid; 
	                 var isExt=deptGroupDr.indexOf(wardRowid);
					 if(isExt>-1){
						 records.push(record);
					 }
		          }); 
                sm.selectRecords(records, true);// 以后每次load数据时，都会默认选中  
            }  
        }  
	});
	var sm = new Ext.grid.CheckboxSelectionModel();
	peDs.setDefaultSort('rowid', 'wardName');
	var peCm = new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),
		{
			id:'wardName',
			header: '检查病区',
			allowBlank: false,
			width:300,
			editable:false,
			dataIndex: 'wardName' ,
			renderer: function(value, metaData, record, rowIndex, colIndex, store){//2016-8-4 add cyl
			    var wardRowid=record.data.rowid;
			    var isExt=deptGroupArr.indexOf(wardRowid);
			    if(isExt>-1){
					metaData.css="oldSelectColor";
			    }
			    return value;
			}
			
		}
	]);
 
	var peGrid = new Ext.grid.GridPanel({//表格
		id:'ward',
		region: 'center',
		store:peDs,
		width: 300,
		cm:peCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:sm,
		loadMask: true
	});

	//--------------------------------------------------------------------------------------------------
	var add2Button = new Ext.Toolbar.Button({
			text:'确定科室'
	});
	//var jxUnitDrStr2="";
	//var jxUnitDrStrn="";	
		
	//定义按钮响应函数
	
	adHandler = function(){
		var rowObi=grid.getSelections();
		var lem = rowObi.length;
		var idStr2="";
		var idStrn="";
//		if(lem < 1){
//			Ext.Msg.show({title:'注意',msg:'请选择需要的科室!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
//			return;
//		}else{
			for(var i=0;i<lem;i++){
				namei=rowObi[i].get("rowid");
				namen=rowObi[i].get("deptGroupName");
				if(idStr2==""){
					idStr2=namei;
					idStrn=namen;
				}else{
					idStr2=idStr2+","+namei
					idStrn=idStrn+","+namen
				}
			}
			jxUnitDrStr2=idStr2;
			jxUnitDrStrn=idStrn;
			jxUnitDrStr2 = trim(jxUnitDrStr2);
			jxUnitDrStrn = trim(jxUnitDrStrn);
			namem=jxUnitDrStr2;
		
			peDs.proxy = new Ext.data.HttpProxy({url:'dhc.qm.uPlanArrangeexe.csp?action=deptfList&dept='+namem+'&periodTxt='+encodeURIComponent(periodtxt)+"&yearPeriod="+yearPeriod+"&userDr="+userDr+"&RowId="+planId});
			peDs.load({params:{start:0, limit:10000}});
//		}
	}
			
	//添加处理函数
	var add2Handler = function(){
		adHandler();
	}	
			
	//添加按钮的监听事件
	add2Button.addListener('click',add2Handler,false);	

	//--------------------------------------------------------------------------------------------------
	nameDs.load({
		params:{start:0,limit:10000},
		callback: function(records, operation, success) {
			if(addOrEdit=="edit"){
			depsm.selectRows(selectDeptArr);
			adHandler();
			}
		}
	});
				
	var addButton = new Ext.Toolbar.Button({
		text:'确定病区'
	});
				
	var jxUnitDrStr="";	
	var jxUnitDrStrl="";	
	//定义按钮响应函数
	Handler = function(){
		var rowObj=peGrid.getSelections();
		var len = rowObj.length;
		var idStr="";
		var idStrl="";
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要的病区!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			for(var i=0;i<len;i++){
				name=rowObj[i].get("rowid");
				namel=rowObj[i].get("wardName");
				if(idStr==""){
					idStr=name;
					idStrl=namel;
				}else{
					idStr=idStr+","+name
					idStrl=idStrl+","+namel
				}
			}
			jxUnitDrStr=idStr;
			jxUnitDrStrl=idStrl;
			win.close();
		}
	};
			
	//添加处理函数
	var addHandler = function(){
		Handler();
		jxUnitDrStr = trim(jxUnitDrStr);
		jxUnitDrStrl = trim(jxUnitDrStrl);
		nameField.setRawValue(jxUnitDrStrl);
		namef=jxUnitDrStr;
		
	}	
			
	//添加按钮的监听事件
	addButton.addListener('click',addHandler,false);
		
	//定义并初始化取消修改按钮
	var cancelButton = new Ext.Toolbar.Button({
		text:'取消'
	});
		
	//定义取消修改按钮的响应函数
	cancelHandler = function(){
		win.close();
	}
			
	//添加取消按钮的监听事件
	cancelButton.addListener('click',cancelHandler,false);
		//------------------------------------------------------------------------------------------------------------------
		//-------------------------------------------------------------------------------------------------------------------
	
	
var buttonStr=[addButton,cancelButton];
	/*//2016-8-4 add cyl
	grid.addListener('cellclick', function (grid, rowIndex, columnIndex, event) {
		console.log(rowIndex);
		adHandler();  
　　}, grid);*/

	//2016-8-24 add cyl
	grid.on('click',function(){
	
		//var selectObj=$("div.x-grid3-row.x-grid3-row-selected");
		var selectObjRowid=$("div#dept  div.x-grid3-row.x-grid3-row-selected  div.x-grid3-cell-inner.x-grid3-col-rowid");
		var deptStr="";
		
		$.each(selectObjRowid,function(i,o){
			var selectRowid=o.innerText;
			if(i==0){
				deptStr=selectRowid;
			}else{
				deptStr=deptStr+","+selectRowid;
			}
			
			});
	
			adHandler2(deptStr); 
			
		});

adHandler2 = function(deptStr){
	namem=trim(deptStr);
	peDs.proxy = new Ext.data.HttpProxy({url:'dhc.qm.uPlanArrangeexe.csp?action=deptfList&dept='+namem+'&periodTxt='+encodeURIComponent(periodtxt)+"&yearPeriod="+yearPeriod+"&userDr="+userDr+"&RowId="+planId});
	peDs.load({params:{start:0, limit:10000}});

}
	

	var win = new Ext.Window({
		title:'检查项目信息',
		width:600,
		height:400,
		closable:true,
		layout: 'border',
		items: [grid,peGrid],
		minWidth: 600, 
		minHeight: 400,
		plain:true,
		modal:true,
		//bodyStyle:'padding:5px;',
		buttonAlign:'center',
		
		buttons: buttonStr
	});
	
	//窗口显示
	win.show();

};