function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}


Name = function(dataStore,grid,pagingTool,addOrEdit,periodtxt,yearPeriod,userDr,planId) {

	//�õ��Ѿ�ѡ�����Ŀid
	if(addOrEdit=="edit"){
		var rowObj=grid.getSelectionModel().getSelections();
		var deptGroupDr=rowObj[0].data.deptGroupDr;
		var userDr=rowObj[0].data.checkUser;
	}else{
		var deptGroupDr="";
	}
	//����ȡ�����ݣ����ҺͲ��������ֳ���
	var deptStr="",wardStr="";
	var deptGroupArr=deptGroupDr.split(",");
	for(var i=0,deptLen=deptGroupArr.length;i<deptLen;i++){
		var deptGroup=deptGroupArr[i];
		var deptWard=deptGroup.split("||");
		var dept=deptWard[1];
		
		deptStr=deptStr+","+dept;
	
	}
	//���年ѡ������
	var selectDeptArr=[];	//����
	var selectWardArr=[];  //����
		
	var nameUrl = '../csp/dhc.qm.uPlanArrangeexe.csp';
	var nameProxy= new Ext.data.HttpProxy({url:nameUrl + '?action=nameList'+'&periodTxt='+encodeURIComponent(periodtxt)+"&yearPeriod="+yearPeriod+"&userDr="+userDr+"&RowId="+planId,method:'POST'});
	var nameDs = new Ext.data.Store({   //��������Դ
			proxy: nameProxy,
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'	
			},['rowid','deptGroupCode','deptGroupName']),
			remoteSort: true	
	});
	var depsm = new Ext.grid.CheckboxSelectionModel();
	//����Ĭ�������ֶκ�������
	nameDs.setDefaultSort('rowid', 'deptGroupName');
	//���ݿ�����ģ��
	var nameCm = new Ext.grid.ColumnModel([
		depsm,
		new Ext.grid.RowNumberer(),
		{
			id:'rowid',
			header: '������ID',
			allowBlank: false,
			width:200,
			editable:false,
			dataIndex: 'rowid',
			hidden:true
	   },{

			id:'deptGroupName',
			header: '������',
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
	//�ⲿָ��
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
                sm.selectRecords(records, true);// �Ժ�ÿ��load����ʱ������Ĭ��ѡ��  
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
			header: '��鲡��',
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
 
	var peGrid = new Ext.grid.GridPanel({//���
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
			text:'ȷ������'
	});
	//var jxUnitDrStr2="";
	//var jxUnitDrStrn="";	
		
	//���尴ť��Ӧ����
	
	adHandler = function(){
		var rowObi=grid.getSelections();
		var lem = rowObi.length;
		var idStr2="";
		var idStrn="";
//		if(lem < 1){
//			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�Ŀ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
			
	//��Ӵ�����
	var add2Handler = function(){
		adHandler();
	}	
			
	//��Ӱ�ť�ļ����¼�
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
		text:'ȷ������'
	});
				
	var jxUnitDrStr="";	
	var jxUnitDrStrl="";	
	//���尴ť��Ӧ����
	Handler = function(){
		var rowObj=peGrid.getSelections();
		var len = rowObj.length;
		var idStr="";
		var idStrl="";
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�Ĳ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
			
	//��Ӵ�����
	var addHandler = function(){
		Handler();
		jxUnitDrStr = trim(jxUnitDrStr);
		jxUnitDrStrl = trim(jxUnitDrStrl);
		nameField.setRawValue(jxUnitDrStrl);
		namef=jxUnitDrStr;
		
	}	
			
	//��Ӱ�ť�ļ����¼�
	addButton.addListener('click',addHandler,false);
		
	//���岢��ʼ��ȡ���޸İ�ť
	var cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��'
	});
		
	//����ȡ���޸İ�ť����Ӧ����
	cancelHandler = function(){
		win.close();
	}
			
	//���ȡ����ť�ļ����¼�
	cancelButton.addListener('click',cancelHandler,false);
		//------------------------------------------------------------------------------------------------------------------
		//-------------------------------------------------------------------------------------------------------------------
	
	
var buttonStr=[addButton,cancelButton];
	/*//2016-8-4 add cyl
	grid.addListener('cellclick', function (grid, rowIndex, columnIndex, event) {
		console.log(rowIndex);
		adHandler();  
����}, grid);*/

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
		title:'�����Ŀ��Ϣ',
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
	
	//������ʾ
	win.show();

};