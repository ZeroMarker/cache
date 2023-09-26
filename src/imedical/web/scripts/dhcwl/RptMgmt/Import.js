(function(){
	Ext.ns("dhcwl.RptMgmt.Import");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.RptMgmt.Import=function(){
	var serviceUrl="dhcwl/rptmgmt/export.csp";
	var outThis=this;
	var inputList= new Array();
	var selImpList=new Array();
	var aryFieldName=new Array();
	var ImpFieldNames=["MenuName","RaqName","CSPName","QueryName","Spec","HisTableName","KPIName","Filter","RowColShow","ProgramLogic","AdvUser","ProMaintainer","DepMaintainer","Demo","CreateDate","UPdateDate","AuxiliaryMenuName","UsedByDep","RaqCSPName"];
	var impExlDataObj;
	
	var fileForm= new Ext.FormPanel(
	{
		frame: true,
		labelWidth: 50, // label settings here cascade unless overridden
		bodyStyle: 'padding:10px;',
		//bodyStyle: 'padding-left:5px;',
		//xtype: 'fieldset',
		autoHeight: true,
		//defaultType: 'radio', // each item will be a radio button
		items: [{
			layout:'form',  
			xtype:'fieldset',  
			////autoHeight:true,  
			defaultType: 'radio', // each item will be a radio button
			title:'选择文件格式',  	
			items:[{
				checked: true,
				hideLabel :true,
				//fieldLabel: '',
				boxLabel: 'excel格式',
				name: 'fileType',
				inputValue: 'excelType'
			}, {
				//fieldLabel: '',
				//labelSeparator: '',
				hideLabel :true,
				boxLabel: 'XML格式',
				name: 'fileType',
				inputValue: 'xmlType'
			}]
		},{
			layout:'form',  
			xtype:'fieldset',  
			title:'选择导入文件',  			
			items:[{
				xtype:'textfield',   
				allowBlank:false,
				//hideLabel:false,
				name:'inputFile',   
				fieldLabel:'文件',
				//buttonText: '浏览2',  
				inputType:'file',
				anchor: '98%'
				//width: 258
			}]			
		}]			
		
    }	
	);	
	
	var fileWin = new Ext.Window({
        width:400,
		height:300,
		resizable:false,
		closable : false,
		title:'选择导入文件',
		modal:true,
		//items:[saveAsForm,rptGrid],
		items:fileForm ,		
		layout:'fit',
			
		buttons: [
		{
			text: '<span style="line-Height:1">取消</span>',
			icon   : '../images/uiimages/cancel.png',
			handler:CloseWin			
		},{
			text: '<span style="line-Height:1">下一步</span>',
			icon   : '../images/uiimages/moveright.png',
			handler: OnFileNext
		}]
	});	
	
	
	function OnFileNext() {
		//

		fileWin.hide();
		importWin.show();
		
		inputList.length=0;
		aryFieldName.length=0;
		selImpList.length=0;
		impExlDataObj=null;

		var fileType=fileForm.getForm().findField("fileType").getGroupValue();
		var path=fileForm.getForm().findField("inputFile").getValue();
		if (fileType=='excelType') {		
			readFileFromExcel(path);	
		}			

		if (fileType=='xmlType') {		
			readFileFromXML(path);	
		}	
	}
	
	//////////////////////////////////////////////////////////////////////
	///导入窗口
	var store = new Ext.data.Store({
        proxy: new Ext.data.MemoryProxy(inputList),
        reader: new Ext.data.ArrayReader({},
        	[	
				{name:'MenuName'},
            	{name:'RaqName'},
				{name:'CSPName'},
				{name:'AuxiliaryMenuName'}
				
       		])
    });	
	
	
	var sm = new Ext.grid.CheckboxSelectionModel(
	{
		listeners :{
			'rowdeselect':function(csm, rowIndex, recorde){
				var RaqName=recorde.get('RaqName');
				var CSPName=recorde.get('CSPName');
				var AuxiliaryMenuName=recorde.get('AuxiliaryMenuName');
				
				selIDsRemove(RaqName+"^"+CSPName+"^"+AuxiliaryMenuName);
			}
			,'rowselect':function(csm, rowIndex, recorde){
				var RaqName=recorde.get('RaqName');
				var CSPName=recorde.get('CSPName');
				var AuxiliaryMenuName=recorde.get('AuxiliaryMenuName');
				selIDsAdd(RaqName+"^"+CSPName+"^"+AuxiliaryMenuName);
			}
		}
	});
	
	var columnModel = new Ext.grid.ColumnModel({
            defaults: {
                width: 100,
                sortable: false
            },
            columns: [
				new Ext.grid.RowNumberer(),
				sm,
				{header:'菜单名称',dataIndex:'MenuName', width: 150},
				{header:'菜单表达式',dataIndex:'RaqName', width: 150},
				{header:'CSP名称',dataIndex:'CSPName', width: 150},
				{header:'当前页面(标题)名称',dataIndex:'AuxiliaryMenuName', width: 150}					
			]
	});
	
	

    var impGrid = new Ext.grid.GridPanel({
        store: store,
        cm: columnModel,
		sm: sm,
        viewConfig: {
            forceFit:true
        }
		
		, 		
		bbar: new Ext.PagingToolbar({
			pageSize:50,
			store:store,
			displayInfo:true,
			displayMsg:'{0}~{1}条,共 {2} 条',
			emptyMsg:'sorry,data not found!',
			listeners :{
				'change':function(pt,page){
					var ID="";
					var AllRowCnt=store.getCount();
					var selRowCnt=0;					
					for(var i=store.getCount()-1;i>-1;i--){
						
						var RaqName=store.getAt(i).get('RaqName');
						var CSPName=store.getAt(i).get('CSPName');
						var AuxiliaryMenuName=store.getAt(i).get('AuxiliaryMenuName');
						if(selIDsCheck(RaqName+"^"+CSPName+"^"+AuxiliaryMenuName)){
							sm.selectRow(i,true,false);
							selRowCnt++
						}
					}
					
					var hd_checker = impGrid.getEl().select('div.x-grid3-hd-checker');
			    	var hd = hd_checker.first();
			    	if(hd!=null ){
			    	    if(AllRowCnt!=selRowCnt && hd.hasClass('x-grid3-hd-checker-on')){
			    	    	hd.removeClass('x-grid3-hd-checker-on');
				    	}else if(AllRowCnt==selRowCnt && !hd.hasClass('x-grid3-hd-checker-on'))
				    	{
				    		hd.addClass('x-grid3-hd-checker-on');
				    	}
			    	}					
				}
			}
		})
		
    });	
	
	
	var importWin=new Ext.Window({
        width:700,
		height:600,
		title:'导出数据',
		layout:'fit',	
		items: impGrid,
		buttons: [
		{
			text: '<span style="line-Height:1">取消</span>',
			icon   : '../images/uiimages/cancel.png',
			handler: CloseWin
		},		{
			text: '<span style="line-Height:1">上一步</span>',
			icon   : '../images/uiimages/moveleft.png',
			handler: OnImportWinPrevious 
		},		{
			text: '<span style="line-Height:1">下一步</span>',
			icon   : '../images/uiimages/moveright.png',
			handler: OnImportWinNext 
		}]		
		
    });
	
	function OnImportWinPrevious() {
		fileWin.show();
		importWin.hide();
	}
		
	function OnImportWinNext() {

		InputExlFile();
	
		CloseWin();
		
	}
	
	function readFileFromExcel(filePath){
		
		try {
	 		oXL = new ActiveXObject('Excel.Application');
	 	}catch (e) {
	 		alert("无法启动Excel!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用");
	 		return false;
	 	}		

        //打开指定路径的excel文件   
		var oWB = oXL.Workbooks.open(filePath); 

		if (!oWB) {
			Ext.Msg.alert("提示","打开文件错误！请确认是否是正确的excel文件！");
			return;
		}
		var strImpData="";
		//操作第一个sheet(从一开始，而非零)   
		try {

			var sheetInx=1;
			oWB.worksheets(sheetInx).select();  
			var oSheet = oWB.ActiveSheet;  
			//使用的行数   
			var rows =oSheet.usedrange.rows.count; 
			//使用的列数
			var colCnt =oSheet.usedrange.Columns.Count;
			//var clsNameRowbegin=2;
			var fieldNameRowBegin=2;
			var dataRowBegin=4;
			var strDataset="";

			//取字段名称
			for (var colInx = 1; colInx <= colCnt; colInx++) {
				var fieldName=oSheet.Cells(fieldNameRowBegin,colInx).value;
				aryFieldName.push(fieldName);
			}

			
			for (var i = dataRowBegin; i <= rows; i++) {
				var strRec="";
				for (var j=1;j<=colCnt;j++) {
					var cellData=oSheet.Cells(i, j).value;
					if (cellData==undefined) cellData="";

					if (oSheet.Cells(i, j).NumberFormatLocal=="yyyy/m/d" || oSheet.Cells(i, j).NumberFormatLocal=="yyyy-m-d") {					
						var d = new Date(cellData);
						cellData=d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate() ;						
					}
					if (strRec!="") strRec=strRec+",";
					strRec=strRec+"'"+aryFieldName[j-1]+"':'"+cellData+"'";
				}
				if (strDataset!="") strDataset=strDataset+',';
				strDataset=strDataset+"{"+strRec+"}"	
			} 
			
			strImpData="{'data':["+strDataset+"]}"	
			impExlDataObj=eval('('+strImpData+')').data;	
			for(var i=0;i<=impExlDataObj.length-1;i++) {
				var aryRec=[];
				var MenuName=impExlDataObj[i].MenuName;
				var RaqName=impExlDataObj[i].RaqName;
				var CSPName=impExlDataObj[i].CSPName;
				var AuxiliaryMenuName=impExlDataObj[i].AuxiliaryMenuName;
				aryRec.push(MenuName);
				aryRec.push(RaqName);
				aryRec.push(CSPName);
				aryRec.push(AuxiliaryMenuName);
				inputList.push(aryRec);
			}
			store.loadData(inputList);


		}catch(e) {  
			oWB.Close();  
			//退出操作excel的实例对象   
			oXL.Application.Quit();  
			CollectGarbage();
			//Ext.Msg.alert("提示",e);
			Ext.Msg.alert("提示","打开文件错误！请确认是否是正确的excel文件！");
			return;
		}  

		oWB.Close();  
		//退出操作excel的实例对象   
		oXL.Application.Quit();  
		//手动调用垃圾收集器   
		CollectGarbage();      	
    	
    }

	function readFileFromXML(filePath){
            	serverSaveFileName=null;
            	
    			var readStr="",theStep=1,sc;
    			var inputCont={};
    			do{
    				readStr=dhcwl.mkpi.util.XML.stepTraverXML(filePath,256);  //dhcwl.mkpi.Util.stepReadFile(file,512);
    				//alert(readStr);
    				inputCont["Node"+(theStep)]=readStr;
    				theStep++;
    			}while(readStr&&readStr!="");

    			dhcwl.mkpi.util.XML.close();

    			Ext.Ajax.request({
					url: encodeURI(serviceUrl+'?action=UPFILE&theStep='+(theStep-1)),
					waitMsg : '正在处理...',
					method:'POST',
					timeout:60000,
					params:inputCont,
					failure: function(result, request){
						Ext.Msg.show({title:'错误1',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){	
						var jsonData;
						try{
           					//win.body.unmask();
							jsonData = Ext.util.JSON.decode( result.responseText );
				
							impExlDataObj=jsonData.data;
							for(var i=0;i<=impExlDataObj.length-1;i++) {
								var aryRec=[];
								var MenuName=impExlDataObj[i].MenuName;
								var RaqName=impExlDataObj[i].RaqName;
								var CSPName=impExlDataObj[i].CSPName;
								var AuxiliaryMenuName=impExlDataObj[i].AuxiliaryMenuName;

								aryRec.push(MenuName);
								aryRec.push(RaqName);
								aryRec.push(CSPName);
								aryRec.push(AuxiliaryMenuName);
								inputList.push(aryRec);
							}
							store.loadData(inputList);							

						}catch(e){
							Ext.Msg.show({title:'错误2',msg:result.responseText,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}

					}
    			});		

	}

	
	impGrid.getStore().on('load',function(storeself,recs,options){
		var param=inputList.join();
		CheckSameRecs();
	});

	function CheckSameRecs() {
		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:'impChk',
			inputList:inputList.join()
		},
		function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				var repDatas=jsonData.root,conKpiCode="";
				var rd,repD="",contFlag=false;
				var tempSm=impGrid.getSelectionModel();
				for(var i=store.getCount()-1;i>=0;i-- ){
					contFlag=false;
					rd=store.getAt(i);
					repD=rd.get("RaqName")+"^"+rd.get("CSPName")+"^"+rd.get("AuxiliaryMenuName");
					repD=repD.toUpperCase( );
					for(var j=repDatas.length-1;j>-1;j--){
						conKpiCode=repDatas[j].repData;
						if(conKpiCode.toUpperCase( )==repD){
							contFlag=true;
							impGrid.getView().getRow(i).style.backgroundColor='red';
						}
					}
					if(!contFlag) tempSm.selectRow(i,true,false);
				}
				
			}else{
				Ext.Msg.show({title:'错误',msg:jsonData.MSG,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;				
			}
		},
		outThis,null,120000);		
	}
	
	function InputExlFile() {
		var realInputList=[];

		for(var i=0;i<=impExlDataObj.length-1;i++) {
			var RaqName=impExlDataObj[i].RaqName;
			var CSPName=impExlDataObj[i].CSPName;
			var AuxiliaryMenuName=impExlDataObj[i].AuxiliaryMenuName;
			for(var j=0;j<=selImpList.length-1;j++) {
				if (RaqName+"^"+CSPName+"^"+AuxiliaryMenuName==selImpList[j]) {
					/*
					for(var x in impExlDataObj[i]) {
						realInputList.push(impExlDataObj[i].[x]);
					}
					*/
					
					for(var k=0;k<ImpFieldNames.length;k++) {
						var fieldName=ImpFieldNames[k];
						realInputList.push(impExlDataObj[i][fieldName]);
					}
				}
			}
		} 		
        dhcwl.mkpi.Util.ajaxExc(serviceUrl,
        	{
				fieldNames:ImpFieldNames.join(),
				impDataObj:realInputList.join(String.fromCharCode(2)),	//$c(2)作为分隔符
				action:"impFromExl"
			}
			,function(jsonData){
				if(jsonData.success==true){
					if (jsonData.tip!="ok") {
						Ext.Msg.alert("提示",jsonData.tip);
					}else{
						Ext.Msg.alert("提示","操作成功！");	
						outThis.OnImpCallback();
					}
			}else{
				Ext.Msg.alert("提示","操作失败！");
				}
				
			},this);		
		
	}	
	
	function CloseWin() {
			fileWin.close();
			importWin.close();
	}
 
	function selIDsRemove(ID) {
		
		if(!ID||ID=="") return;
		
		var len=selImpList.length;
		for(var i=0;i<len;i++){
			if(selImpList[i]==ID){
				for(var j=i;j<len;j++){
					selImpList[j]=selImpList[j+1];
				}
				selImpList.length=len-1;
				break;
			}
		}			
	}
	
	function selIDsAdd(ID) {
		if(!ID||ID=="") return;
		for(var i=selImpList.length-1;i>-1;i--){
			if(selImpList[i]==ID)
				return;
		}
		selImpList.push(ID);		
	}

	function selIDsCheck(ID) {
		if(!ID||ID=="") return false;
		for(var i=selImpList.length-1;i>-1;i--){
			if(selImpList[i]==ID){
				return true;
			}
		}
		return false;		
	}


	this.showFileWin=function() {
		fileWin.show();
	}
	
	this.initParam=function(inParam) {
	}
}

