var UserId=session['LOGON.USERID'];	
var GroupId = session['LOGON.GROUPID'];
var SiteCode=session['LOGON.SITECODE'];

// /����: GridColSet.js
// /����: grid������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.04.12
///gridSelected:��Ҫ���������Ե�grid����
///AppName:gridSelected���ڵĽ�������
function GridColSet(gridSelected,AppName) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var SaveFlag=false;
	// ���水ť
	var SaveBBT = new Ext.Toolbar.Button({
		id : "SaveBBT",
		text : '����',
		tooltip : '�������',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			// ����������
			SaveData();	
			SaveFlag=true;
		}
	});
	
	
	// ������������Ϣ
	function SaveData() {
		var StrData="";
		var GridId=gridSelected.getId();		
		var UserFlag=Ext.getCmp("UserFlag").getValue();
		var GroupFlag=Ext.getCmp("GroupFlag").getValue();
		var SaveMod="";
		var SaveValue="";
		if(UserFlag==true){
			SaveMod="SSUser";
			SaveValue=UserId;
		}
		else if(GroupFlag==true){
			SaveMod="SSGroup";
			SaveValue=GroupId;
		}else{
			SaveMod="SITE";
			SaveValue=SiteCode;
		}
		
		//ȡ��ϸ��Ϣ
		var rowCount = MasterInfoGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {				
			var rowData = MasterInfoStore.getAt(i);
			
			var rowid=rowData.get("rowid");
			var id = rowData.get("id");
			var Name=rowData.get("name");   
			var Header = rowData.get("header");	
			var Width = rowData.get("width");
			var Align = rowData.get("align");
			var Sort = rowData.get("sortable");
			var Hidden = rowData.get("hidden");
			var SeqNo=rowData.get("seqno");
			var Format=rowData.get("format");
			var DataType="" ;
			var EnterSort=rowData.get("entersort");
			//˳���^��id^�б���^���^���뷽ʽ^�Ƿ�����^�Ƿ�����^����^��ʾ��ʽ^��������
			if(StrData=="")
			{
				StrData=rowid+"^"+SeqNo+"^"+id+"^"+Header+"^"+Width+"^"+Align+"^"+Sort+"^"+Hidden+"^"+Name+"^"+Format+"^"+DataType+"^"+EnterSort;
			}
			else
			{
				StrData=StrData+xRowDelim()+rowid+"^"+SeqNo+"^"+id+"^"+Header+"^"+Width+"^"+Align+"^"+Sort+"^"+Hidden+"^"+Name+"^"+Format+"^"+DataType+"^"+EnterSort;
			}			
		}
		if(StrData==""){
			Msg.info("warning","����û�иı䣬����Ҫ����!");
			return;
		}
		var url ="dhcst.stksysgridsetaction.csp?actiontype=Save";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params:{AppName:AppName,GridId:GridId,SaveMod:SaveMod,ModValue:SaveValue,CspName:App_MenuCspName,ListData:StrData},
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							var MainId=jsonData.info;
							getColSetDetail(GridId,SaveMod,SaveValue);;
							Msg.info("success", "����ɹ�!");
							
						} else {
							Msg.info("error", "����ʧ��:"+jsonData.info);
						}
					},
					scope : this
				});
	}	
	
	// ����ĳ��
	function MoveUpHandler() {

		var id="";
		var rows=MasterInfoGrid.getSelectionModel().getSelections() ; 
		if(rows.length==0){
			Msg.info("error", "��ѡ��Ҫ�ƶ��ļ�¼��");
			return;
		}
		else {
			record=rows[0];
			var index=MasterInfoStore.indexOf(record);//indexof��ȡ�����ݵ�Record�ڻ����е�λ��������
			//��ǰ�����м�¼ʱ, �Ž������Ʋ���
			if(index>0){
				var lastRecord=MasterInfoStore.getAt(index-1);
				var seqno=record.get("seqno");
				var lastreqno=lastRecord.get("seqno");
				record.set("seqno",lastreqno);
				lastRecord.set("seqno",seqno);
				MasterInfoStore.sort("seqno","ASC");
			}
		}
	}	

	// ����ĳ��
	function MoveDownHandler() {

		var id="";
		var rows=MasterInfoGrid.getSelectionModel().getSelections() ; 
		if(rows.length==0){
			Msg.info("error", "��ѡ��Ҫ�ƶ��ļ�¼��");
			return;
		}
		else {
			record=rows[0];
			
			var index=MasterInfoStore.indexOf(record);
			
			//ֻ�е�����һ��ʱ�Ž������Ʋ���
			if(index+1<MasterInfoStore.getCount()){
				var nextRecord=MasterInfoStore.getAt(index+1);
				var seqno=record.get("seqno");
				var nextseqno=nextRecord.get("seqno");
				record.set("seqno",nextseqno);
				nextRecord.set("seqno",seqno);
				
				MasterInfoStore.sort("seqno","ASC");
			}
		}
	}	
	
	//����records���Ƿ��ж�Ӧ��col����
	function FindRecord(colname,records){
		if(records==null){
			return false;      //û�ж���
		}
		if(records.length<1){
			return false;  
		}
		var findFlag=false;
		for(var i=0;i<records.length;i++){
			var record=records[i];
			var name=record.get("name");
			if(colname==name){
				findFlag=true;   //���ڶ���
				break;
			}
		}
		return findFlag;
	}
	// ����grid�г�ʼ������Ϣ
	function InitSave(records) {
		var StrData="";
		var GridId=gridSelected.getId();		
		var UserFlag=Ext.getCmp("UserFlag").getValue();
		var GroupFlag=Ext.getCmp("GroupFlag").getValue();
		var SaveMod="";
		var SaveValue="";
		if(UserFlag==true){
			SaveMod="SSUser";
			SaveValue=UserId;
		}
		else if(GroupFlag==true){
			SaveMod="SSGroup";
			SaveValue=GroupId;
		}else{
			SaveMod="SITE";
			SaveValue=SiteCode;
		}
		
		var ColCount=0;
		var columnModel=gridSelected.getColumnModel();
		if(columnModel){
			ColCount=columnModel.getColumnCount();
		}
		// ˳���^��id^�б���^���^���뷽ʽ^�Ƿ�����^�Ƿ�����
		for (var i = 1; i < ColCount; i++) {
			var column=columnModel.config[i];
			var ColId=columnModel.getColumnId(i); //column.id;
			var Name=column.dataIndex;	
			if(FindRecord(Name,records)==false){
											//column.getDataIndex(i);  //column.getColumnId(i);
				var Width=column.width;								//getColumnWidth(i);
				var Header=column.header;							//getColumnHeader(i);
				var Align=column.align; 
				if(!Align){
					Align="";
				}
				var Sortable=(columnModel.isSortable(i)==true?'Y':'N');								//column.sortable;	
				var Hide=(columnModel.isHidden(i)==true?'Y':'N');								//;column.hideable
				var Format="";
				var DataType="";
				var EnterSort=0
				if(Name==""){
					continue;
				}
				if(StrData=="")
				{		
					StrData="^"+i+"^"+ColId+"^"+Header+"^"+Width+"^"+Align+"^"+Sortable+"^"+Hide+"^"+Name+"^"+Format+"^"+DataType+"^"+EnterSort;
				}
				else
				{
					StrData=StrData+xRowDelim()+"^"+i+"^"+ColId+"^"+Header+"^"+Width+"^"+Align+"^"+Sortable+"^"+Hide+"^"+Name+"^"+Format+"^"+DataType+"^"+EnterSort;
				}
			}
		}	
		if(StrData==""){
			return;
		}
		var url ="dhcst.stksysgridsetaction.csp?actiontype=Save";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params:{AppName:AppName,GridId:GridId,SaveMod:SaveMod,ModValue:SaveValue,CspName:App_MenuCspName,ListData:StrData},
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							var MainId=jsonData.info;
							getColSetDetail(GridId,SaveMod,SaveValue);
							//Msg.info("success", "����ɹ�!");
							
						} else {
							Msg.info("error", "��ʼ�����������ʧ��:"+jsonData.info);
						}
					},
					scope : this
				});
	
	}	
	
	// 3�رհ�ť
	var closeBT = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '�رս���',
				iconCls : 'page_close',
				height:30,
				width:70,
				handler : function() {
					if(SaveFlag==true){
						RefreshGridColSet(gridSelected,AppName);
					}
					window.close();
				}
			});
	
	
	var alignStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['left', 'left'], ['right', 'right'], ['center', 'center']]
				});
					
	// ����·��
	var MasterInfoUrl = "";
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["rowid","id","header","width","align", "name","sortable", "hidden",{name:'seqno',type: 'float'},"format","entersort"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "rowid",
				fields : fields
			});
	// ���ݼ�
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				remoteSort:false,
				sortInfo:{
					field:"seqno",
					direction:"ASC"
				}
			});
	// the check column is created using a custom plugin
    var ColumnSort = new Ext.grid.CheckColumn({
       header: '�Ƿ�����',
       dataIndex: 'sortable',
       width: 75
    });
	var ColumnHidden = new Ext.grid.CheckColumn({
	   header: '�Ƿ�����',
	   dataIndex: 'hidden',
	   width: 75
	});
	var ColumnEnterSort = new Ext.grid.CheckColumn({
	   header: '�س���ת',
	   dataIndex: 'entersort',
	   width: 75
	});
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header:'rowid',
				dataIndex:'rowid',
				hidden:true
			},{
				header : "����",
				dataIndex : 'name',
				width : 100,
				align : 'left',
				sortable : false,
				hidden : false
			},{
				header : "id",
				dataIndex : 'id',
				width : 100,
				align : 'left',
				sortable : false,
				hidden : false
			}, {
				header : "����",
				dataIndex : 'header',
				width : 100,
				align : 'left',
				sortable : false,
				editor : new Ext.form.TextField({
					selectOnFocus : true,
					allowBlank : false
				})
			}, {
				header : "���",
				dataIndex : 'width',
				width : 50,
				align : 'right',
				sortable : false,
				editor : new Ext.form.NumberField({
					selectOnFocus : true,
					allowBlank : false,
					allowNegative:false
				})
			}, {
				header : "��ʽ",
				dataIndex : 'format',
				width : 75,
				align : 'left',
				sortable : false,
				editor : new Ext.form.TextField({
					selectOnFocus : true,
					allowBlank : false,
					regex:/^#{1,3},#{3}$|^#*\.0{0,4}$|^%$/
				})
			},{
				header : "���뷽ʽ",
				dataIndex : 'align',
				width : 75,
				align : 'left',
				sortable : false,
				editor : new Ext.form.ComboBox({
					store : alignStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					mode:'local',
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					editable:false,
					valueNotFoundText : ''
				})
			}, 
				ColumnSort, 
				ColumnHidden,
				ColumnEnterSort
			]);
	MasterInfoCm.defaultSortable = false;
	
	var MasterInfoGrid = new Ext.grid.EditorGridPanel({
				title : '������',
				region : 'center',
				height:400,
				cm : MasterInfoCm,
				//sm : new Ext.grid.CellSelectionModel({}),
				sm : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
				store : MasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				plugins: [ColumnSort,ColumnHidden,ColumnEnterSort],
				clicksToEdit : 1
			});

	// ����ȫ��
	var GroupFlag = new Ext.form.Radio({
				boxLabel : '���û���',
				id : 'GroupFlag',
				name : 'SaveFlag',
				anchor : '90%',
				width : 100,
				height : 30 ,
			 // bodyStyle : 'overflow-x:hidden; overflow-y:scroll',
				checked : false
	});
	// �û�
	var UserFlag = new Ext.form.Radio({
				boxLabel : '���û�',
				id : 'UserFlag',
				name : 'SaveFlag',
				anchor : '90%',
				width : 100,
				height : 30 ,
				checked : false
	});
	
	// �û�
	var SiteFlag = new Ext.form.Radio({
				boxLabel : '��վ��',
				id : 'SiteFlag',
				name : 'SaveFlag',
				anchor : '90%',
				width : 100,
				height : 30 ,
				checked : true
	});
	
	// ���ư�ť
	var MoveUpBT = new Ext.Button({
		id : "MoveUpBT",
		text : '����',
		tooltip : '�������',
		width : 70,
		height : 30,
		iconCls : 'page_moveup',
		handler : function() {
			// ����
			MoveUpHandler();			
		}
	});
	// ���ư�ť
	var MoveDownBT = new Ext.Button({
		id : "MoveDownBT",
		text : '����',
		tooltip : '�������',
		width : 70,
		height : 30,
		iconCls : 'page_movedown',
		handler : function() {
			// ����
			MoveDownHandler();			
		}
	});
	var InfoButton= new Ext.Panel({
		frame : true,
		//autoHeight : true,
		region : 'east',
		height:400,
		width:100,
		layout:'fit',
		//anchor: '100%',
		id : "InfoButton",
	    layout: {
            type:'vbox',
            padding:'5',
            pack:'center',
            align:'center'
        },
		items : [MoveUpBT,MoveDownBT]							
	});
	var InfoForm= new Ext.Panel({
			frame : true,
			defaults:{labelAlign : 'right',border:false},			
			xtype : 'fieldset',
			title : '',						
			layout : 'column',
			items : [{
						columnWidth : .3,	
						xtype : 'fieldset',
						items : [GroupFlag]
					}, {
						columnWidth : .3,	
						xtype : 'fieldset',
						items : [UserFlag]
					}, {
						columnWidth : .3,
						xtype : 'fieldset',
						items : [SiteFlag]
					}]				
		});
	var HisListTab = new Ext.Panel({
			region : 'south',
			height : 50,
			layout:'fit',
			items:[InfoForm]					
		});

	var window = new Ext.Window({
				title : '������',
				width :document.body.clientWidth*0.7,
				height : document.body.clientHeight*0.85,
				layout : 'border',
				modal:true,
				items : [MasterInfoGrid,HisListTab,InfoButton],
				tbar : [SaveBBT,  closeBT]
			});
	window.show();
	
	// ����grid��������ϸ
	function getColSetDetail(GridId,SaveMod,SaveValue) {
		if (AppName == null || AppName=="") {
			return;
		}
		if (GridId == null || GridId=="") {
			return;
		}
		if (SaveMod == null || SaveMod=="") {
			return;
		}
		if (SaveValue == null || SaveValue=="") {
			return;
		}
		var url = "dhcst.stksysgridsetaction.csp?actiontype=Query&AppName="+AppName+"&GridId="
				+ GridId+"&SaveMod="+SaveMod+"&ModValue="+SaveValue+"&CspName="+App_MenuCspName;
		MasterInfoStore.proxy = new Ext.data.HttpProxy({
					url : url
				});
		MasterInfoStore.removeAll();
		MasterInfoStore.load();
	}  
	
	MasterInfoStore.on('load',function(store,records,opts){
		InitSave(records);
	});
	
	// ����grid������
	function getColSet() {
		//����grid������
		var GridId=gridSelected.getId();
		var url = "dhcst.stksysgridsetaction.csp?actiontype=GetSaveMod&AppName=" + AppName+"&GridId="+GridId+
				"&GroupId="+GroupId+"&UserId="+UserId+"&SiteCode="+SiteCode+"&CspName="+App_MenuCspName;
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : '������...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							var SaveInfo=jsonData.info;
							if(SaveInfo!=""){
								var ArrInfo=SaveInfo.split("^");
								var SaveMod=ArrInfo[0];
								var ModValue=ArrInfo[1];
								
								if(SaveMod=="SSUser"){
									Ext.getCmp("UserFlag").setValue(true);								
								}
								else if(SaveMod=="SSGroup"){
									Ext.getCmp("GroupFlag").setValue(true);									
								}else{
									Ext.getCmp("SiteFlag").setValue(true);									
								}								
								getColSetDetail(GridId,SaveMod,ModValue);
							}else {
								InitSave(); //����û�б���grid��������Ϣ�����Զ�����grid�г�ʼ����
							}
						}
					},
					scope : this
				});
	
	}	
	
	//�Զ���ʾgridSelected������
	getColSet();
}

//ǧ��λ��ʾ
function commaRender(value){
	//����������ֵĻ�ԭֵ����
	if(/^\d*\.{0,1}\d*$/.test(value)==false){
		return value;
	}
	var newValue=value;
	if(Number(value)>=1000){
		if(value.toString().indexOf(".")!=-1){
			value=DecimalFormat(value,2);
		}
		var inputValue=value.toString();
		if(inputValue.indexOf(".")!=-1){
			var inputString=inputValue.split(".");
			var decimalString=inputString[1];
			var inputValue=inputSting[0];   //��������
		}
		var outputString="";
		var count=0;
		for(i=inputValue.length-1;i>=0&&inputValue.charAt(i)!="-";i--){
			if(count==3){
				outputString+=",";
				count=0;
			}
			outputString+=inputValue.charAt(i);
			count++;
		}
		if(inputValue.charAt(0)=="-"){
			outputString+="-";
		}
		
		newValue=outputString.split("").reverse().join("")+"."+decimalString;
	}
	return newValue;
}
	
//�ٷֺ���ʾ
function percentRender(value){
	//����������ֵĻ�ԭֵ����
	if(/^\d*\.{0,1}\d*$/.test(value)==false){
		return value;
	}
	return Number(value).mul(100).toString()+"%";
}
//��ʽ��С��λ��
function decimalRender(format){
	return function(value){
		//����������ֵĻ�ԭֵ����
		if(/^\d*\.{0,1}\d*$/.test(value)==false){
			return value;
		}
		var decimalLen=format.split(".")[1].length;
		var newValue=DecimalFormat(value,decimalLen);
		return newValue;
	}
}

// ˢ��Ŀ��grid������
function RefreshGridColSet(Grid,AppName) {
	
		var GridId=Grid.getId();
		var url = "dhcst.stksysgridsetaction.csp?actiontype=GetGridColSet&AppName=" + AppName+"&GridId="+GridId+
		"&GroupId="+GroupId+"&UserId="+UserId+"&SiteCode="+SiteCode+"&CspName="+App_MenuCspName;;;
		var response = ExecuteDBSynAccess(url);	
		response=response.replace(/\r\n/g,'');
		var jsonData=Ext.util.JSON.decode(response);
		var ColInfoStr=jsonData.info;
		if(ColInfoStr==""){
			return;
		}
		
		var ListColArr=new Array();
		ListColArr=ColInfoStr.split(",");
		var ColNum=ListColArr.length;
		if(ColNum<1){
			return;
		}
		//.s data1=ColKey_"^"_Name_"^"_Header_"^"_Width_"^"_Align
		//.s data2=Format_"^"_Hide_"^"_Nessary_"^"_SeqNo_"^"_DataType
		var columnModel=Grid.getColumnModel();
		
		/*
		//����ԭgrid������
		var ColCount=0;
		var OldConfig=new Array();
		if(columnModel){
			ColCount=columnModel.getColumnCount();
		}
		for (var i = 0; i < ColCount; i++) {
			OldConfig[i]=columnModel.config[i];
		} */
		//
		/*
		Object.prototype.clone = function() {
		  var newObj = (this instanceof Array) ? [] : {};
		  for (i in this) {
		    if (i == 'clone') continue;
		    if (this[i] && typeof this[i] == "object") {
		      newObj[i] = this[i].clone();
		    } else newObj[i] = this[i]
		  } return newObj;
		}; */
		var NewConfig=columnModel.config.slice(0);  //��������;
		//var NewConfig=columnModel.config.clone();
		//NewConfig=OldConfig;
		
		for(var i=0;i<ColNum;i++){
			var ColInfo=ListColArr[i];
			var ColInfoArr=ColInfo.split("^");			
			var ColKey=ColInfoArr[0];
			var Header=ColInfoArr[2];
			var Width=ColInfoArr[3];
			var Align=ColInfoArr[4];
			var Format=ColInfoArr[5];
			var Hide=ColInfoArr[6];
			var SeqNo=ColInfoArr[8];
			var Sort=ColInfoArr[10];
			var EnterSort=ColInfoArr[11];
			var ColIndex=columnModel.getIndexById(ColKey);
			var column=columnModel.config[ColIndex];
			if(column)
			{
					column.width=parseFloat(Width);
					column.header=Header;
					column.align=Align;
					if(Sort=="Y"){
						column.sortable=true;
					}else{
						column.sortable=false;
					}
					if(Hide=="Y"){
						column.hidden=true;
					}else{
						column.hidden=false;
					}
					if(Format=="%"){
						column.renderer=percentRender;
					}else if(Format.indexOf(",")!=-1){
						column.renderer=commaRender;
					}else if(Format.indexOf(".")!=-1){
						column.renderer=decimalRender(Format);
					}
					if(EnterSort>0){
						var cl=column.getCellEditor();
						if(!Ext.isEmpty(cl)){
							column.enterSort=EnterSort
						}
					}
					NewConfig[SeqNo]=column;
			}
		}
		
		Grid.reconfigure(Grid.getStore(), new Ext.grid.ColumnModel(NewConfig));
		//columnModel.setConfig(NewConfig,true);		//Specify true to bypass cleanup which deletes the totalWidth and destroys existing editors
}	