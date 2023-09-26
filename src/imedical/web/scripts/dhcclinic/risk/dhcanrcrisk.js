Ext.onReady(function(){
    Ext.QuickTips.init();
    //alert(EpisodeID);
    if 	(EpisodeID==""){alert("��ѡ��һ�����ﲡ�ˣ�");return;}	
    var bd = Ext.getBody();
    

    var txtName=new Ext.form.TextField({
	    id:'txtName',
		fieldLabel:'����',
		anchor:'100%',
		readOnly:true	    
    });
    var txtMedCareNo=new Ext.form.TextField({
	    id:'txtMedCareNo',
		fieldLabel:'������',
		anchor:'100%',
		readOnly:true    
    });
    var txtGender=new Ext.form.TextField({
	    id:'txtGender',
		fieldLabel:'�Ա�',
		anchor:'100%',
		readOnly:true	    
    });
    var txtAge=new Ext.form.TextField({
	    id:'txtAge',
		fieldLabel:'����',
		anchor:'100%',
		readOnly:true   
    });
    var pnlName=new Ext.Panel({
	    id:'pnlName',
		layout:'form',
		columnWidth:.25,
        items:[
        	txtName
        ]	
    });
    var pnlMedCareNo=new Ext.Panel({
	    id:'pnlMedCareNo',
		layout:'form',
		columnWidth:.25,
        items:[
        	txtMedCareNo
        ]	
    });
	var pnlGender=new Ext.Panel({
	    id:'pnlGender',
		layout:'form',
		columnWidth:.25,
        items:[
        	txtGender
        ]	
    });
	var pnlAge=new Ext.Panel({
	    id:'pnlAge',
		layout:'form',
		columnWidth:.25,
        items:[
        	txtAge
        ]	
    });
    var pnlPatInfo=new Ext.Panel({
		id:'pnlPatInfo',
		layout:'column',	
        items:[
        	pnlName,
        	pnlMedCareNo,
        	pnlGender,
        	pnlAge
        ]	
	});
    
    var txtPrediag=new Ext.form.TextField({
	    id:'txtPrediag',
		fieldLabel:'��ǰ���',
		anchor:'100%',
		readOnly:true   
    });  
	var pnlPrediag=new Ext.Panel({
	    id:'pnlPrediag',
		layout:'form',
        items:[
        	txtPrediag
        ]	
    });    
    var txtSysComplication=new Ext.form.TextField({
	    id:'txtSysComplication',
		fieldLabel:'ȫ��ϵͳ����֢',
		anchor:'100%',
		readOnly:true   
    });  
    var txtOPComplication=new Ext.form.TextField({
	    id:'txtOPComplication',
		fieldLabel:'������ز���֢',
		anchor:'100%',
		readOnly:true   
    });  
	var pnlComplication=new Ext.Panel({
	    id:'pnlComplication',
		layout:'form',
		//frame:true,
		title:'���󲢷�֢',
        items:[
        	txtSysComplication,
        	txtOPComplication
        ]		    
    });
    var pnlTopInfo=new Ext.Panel({
		id:'pnlTopInfo',
		frame:true,
		layout:'form',	
        items:[
        	pnlPatInfo,
        	pnlPrediag
        	//pnlComplication
        ]	
	}); 
  
    //------------------------�����Ѷȷּ�-----------------------------------//
	var cmbPreOpNameStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	var cmbPreOpNameStore=new Ext.data.Store({
		proxy:cmbPreOpNameStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'rowid', mapping: 'rowid'},
			{name: 'OPTypeDes', mapping: 'OPTypeDes'},
			{name: 'OPCategory', mapping: 'OPCategory'}			
		])
	});
	var cmbPreOpName=new Ext.form.ComboBox({
		id: 'cmbPreOpName',
	    fieldLabel: '������������',	 
		valueField : 'rowid',
	    displayField: 'OPTypeDes',
	    store:cmbPreOpNameStore,
	    minChars : 1,
	    triggerAction : 'all',
	    anchor:'80%',
	    listeners: {  //ΪCombo���select�¼�
			select: function(cmbPreOpName, record, index) {   // ���¼��᷵��ѡ�е����Ӧ�� store�е� recordֵ. index���������к�.
				//alert(record.get('OPCategory'));
				for(var j=0;j<OPGrid.getStore().getCount();j++)  //�����Ѷȷּ�
				{
					var obj=OPGrid.getStore().getAt(j);
					if (obj.get('OpDifficulty')==record.get('OPCategory'))
					{		
						diffint=j	
						setTimeout(function(){
							OPGrid.getSelectionModel().selectRow(diffint);
 						},500);
					}		  
		 		}	
			}
		}

	});    
    var OpSm = new Ext.grid.CheckboxSelectionModel({
	    header:'',
	    dataIndex:'OPChecked'
	    //width:150
	    });    
    if (CtlocId=="36")  //������Ʒּ�
    {
    	var OPData=[['һ������','���������������������λ��������1������',,'1'],
    		['��������','��Ƥ����,���״������������׾����2������',,'2'],
    		['��������','��ǻ��������ȥ��������ǻ�������������г�����3������',,'3'],
    		['�ļ�����','ǰ���ٰ�����������������ǻ���ȸ�ϸ�����г�����4������',,'4']    		
    	];
    }
    else if (CtlocId=="48")  //��ǻ�Ʒּ�
    {
    	var OPData=[['һ������','�����γ�����ŧ���п�����ǳ���ܰͽ������������������崴��(С)',,'1'],
    		['��������','���Ѷ����޸���ȡ�Ѱ�������ǻ����֯�����г�����',,'2'],
    		['��������','�����п����������ժ���������������г�����������ժ�����������׹γ����������������崴(��)',,'3'],
    		['�ļ�����','������Һ�����г�����Ѫ�ܵ�����Ƥ���޸������������������ܰ���ɨ��',,'4']    		
    	];
    }
    else
    {
	    var OPData=[['һ������','������������������Ѫ����������������Ѫ����Ӱ',,'1'],
    		['��������','����Ѫ������������Χ������ǻ������',,'2'],
    		['��������','����������Ѫ�ܡ���Χ������������������Ĥ����������Ѫ��ǻ������',,'3'],
    		['�ļ�����','���ӵĴ�Ѫ��������ǻ�����ơ���ʽ����',,'4']    		
    	];
    }  
	var OPStore = new Ext.data.Store({
		proxy:new Ext.data.MemoryProxy(OPData),  
		reader:new Ext.data.ArrayReader({},
		[  
			{name:'OpDifficulty'},  
			{name:'OpDifficultyDesc'},
			{name:'OPChecked'},
			{name:'OpCode'}
			])
		});
	var OPGrid = new Ext.grid.GridPanel({
		id:'OPGrid',
		store:OPStore,//���ݴ洢��  
		//sm:OpSm,//��ѡ��  
		autoHeight:true,
		columns:[
			{header:'�����Ѷ�',dataIndex:'OpDifficulty',width:200}, 
			{header:'�ּ�',dataIndex:'OpDifficultyDesc',width:750}
			,OpSm
			,{header:'OpCode',dataIndex:'OpCode',hidden:true}
	    ]
		}); 
	OPStore.load();

	var pnlOpDifficulty=new Ext.Panel({
	    id:'pnlOpDifficulty',
	    title:'�����Ѷȷּ�',
		layout:'form',
		frame:true,
        items:[
        	cmbPreOpName,
        	OPGrid
        ]	
    }); 
    //------------------------�����Ѷȷּ�-----------------------------------//
    //------------------------��������ASA �ּ�-----------------------------------//
    var cmbASAStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	var cmbASAStore=new Ext.data.Store({
		proxy:cmbASAStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'ASAId', mapping: 'Id'},
			{name: 'ASADesc', mapping: 'Description'}
		])
	});
	var cmbASA=new Ext.form.ComboBox({
		id: 'cmbASA',
	    fieldLabel: '����ASA�ּ�',
		valueField : 'ASAId',
	    displayField: 'ASADesc',
	    store:cmbASAStore,
	    minChars : 1,
	    triggerAction : 'all',
	    anchor:'80%'
	}); 
    var ASASm=new Ext.grid.CheckboxSelectionModel({
	    header:'',
	    dataIndex:'ASAChecked'
	    });  
    var ASAData=[['��','��������,���ֲ�������,��ϵͳ�Լ���',,'1'],
    		['��','����Ȼ��ж�ϵͳ�Լ���',,'2'],
    		['��','������ϵͳ�Լ���,�ճ������,��δɥʧ��������',,'3'],
    		['����','������ϵͳ�Լ���,��ɥʧ��������,��в������ȫ',,'4'],
    		['V��','����Σ��,��������ά�ֵı�������',,'5']
    	];  
	var ASAStore=new Ext.data.Store({
		proxy:new Ext.data.MemoryProxy(ASAData),  
		reader:new Ext.data.ArrayReader({},
		[  
			{name:'ASADifficulty'},  
			{name:'ASADifficultyDesc'},
			{name:'ASAChecked'},
			{name:'ASACode'}
			])
		});
	ASAStore.load();  
	var ASAGrid=new Ext.grid.GridPanel({  
		store:ASAStore,//���ݴ洢��  
		autoHeight:true,
		width:400,
		//sm: new Ext.grid.RowSelectionModel({singleSelect:true}), //����Ϊ����ѡ��ģʽ
		columns:[
			{header:'ASA',dataIndex:'ASADifficulty',width:50}, 
			{header:'�ּ�',dataIndex:'ASADifficultyDesc',width:330},
			ASASm,
			{header:'ASACode',dataIndex:'ASACode',hidden:true}
		]
		});
		/*
	cmbASA.on('select',function(){
		for(var i=0;i<ASAGrid.getStore().getCount();i++)
		{
			
			var obj=ASAGrid.getStore().getAt(i);
			var ASACode=obj.get('ASACode');
			if(cmbASA.getRawValue()==ASACode)
			{
				//ASAStore.selectRow(index);
				//obj.set('ASAChecked',true);
				obj.set('ASAChecked',!obj.get('ASAChecked'));
				alert(obj.get('ASAChecked'))
				//ASAStore.reload();
			}
		}
		
		
	})*/
	var pnlASADifficulty=new Ext.Panel({
	    id:'pnlASADifficulty',
	    title:'ASA�ּ�',
		layout:'form',
		columnWidth:.4,
		frame:true,
        items:[
        	cmbASA,
        	ASAGrid
        ]	
    }); 
    //------------------------��������ASA �ּ�-----------------------------------//
    //------------------------��������-----------------------------------//
 	var cmbOPSortData=[
		['B','����']
		,['R','����']
		,['E','����']
		];
	var cmbOPSortStoreProxy = new Ext.data.MemoryProxy(cmbOPSortData);
	var columnName = new Ext.data.Record.create([
		{ name: "OPTypeCode", type: "string" },
		{ name: "OPTypeDesc", type: "string" }
		]);
	var reader = new Ext.data.ArrayReader({}, columnName);
	var cmbOPSortStore = new Ext.data.Store({
		proxy: cmbOPSortStoreProxy,
        reader: reader,
		autoLoad: true
		});
	cmbOPSortStore.load();	
	var cmbOPSort=new Ext.form.ComboBox({
		id:'cmbOPSort'
		,store :cmbOPSortStore		
		,minChars : 1
		,displayField:'OPTypeDesc'
		,fieldLabel:'��������'
		,valueField:'OPTypeCode'
		,triggerAction : 'all'
		,anchor : '80%'
	});   
    var OPSortSm=new Ext.grid.CheckboxSelectionModel({
	    header:'',
	    dataIndex:'OPSortChecked'
	    });  
    var OPSortData=[['��������','����Ӱ����������,Ԥ�ڸ�����������,���ڽ�������',,'B'],
    		['��������','������в���١�֫�������,�辡���������',,'R'],
    		['��������','ͻ��������в���١�֫�������,�輱���������',,'E']
    	];  
	var OPSortStore=new Ext.data.Store({
		proxy:new Ext.data.MemoryProxy(OPSortData),  
		reader:new Ext.data.ArrayReader({},
		[  
			{name:'OPSort'},  
			{name:'OPSortDesc'},
			{name:'OPSortChecked'},
			{name:'OPType'}
			])
		});
	OPSortStore.load();  
	var OPSortGrid=new Ext.grid.GridPanel({  
		store:OPSortStore,//���ݴ洢��  
		autoHeight:true,
		width:530,
		columns:[
			{header:'��������',dataIndex:'OPSort',width:100}, 
			{header:'�ּ�',dataIndex:'OPSortDesc',width:410},
			OPSortSm,
			{header:'OPType',dataIndex:'OPType',hidden:true}
		]
		});  
	var pnlOPSort=new Ext.Panel({
	    id:'pnlOPSort',
	    title:'��������',
		layout:'form',
		frame:true,
        items:[
        	cmbOPSort,
        	OPSortGrid
        ]	
    });
    //---------------------combox data------------------------------------
	cmbPreOpNameStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'FindOrcOperation';
		param.Arg1=cmbPreOpName.getRawValue();
		param.Arg2=UserId;
		//param.Arg3="";
		param.ArgCnt=2;
	});
	cmbPreOpNameStore.load({});   
  	cmbASAStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCom';
		param.QueryName = 'FindASAClass';
		param.ArgCnt=0;
	});
	cmbASAStore.load({});  
    //------------------------��������-----------------------------------//


    var txtDoc=new Ext.form.TextField({
	    id:'txtDoc',
		fieldLabel:'���סԺҽʦ',
		anchor:'100%',
		readOnly:true	    
    });
    var txtDate=new Ext.form.TextField({
	    id:'txtDate',
		fieldLabel:'����',
		anchor:'100%',
		readOnly:true    
    });
	var pnlDoc=new Ext.Panel({
	    id:'pnlDoc',
		layout:'form',
		columnWidth:.5,
        items:[
        	txtDoc
        ]	
    });
    var pnlDate=new Ext.Panel({
	    id:'pnlDate',
		layout:'form',
		columnWidth:.5,
        items:[
        	txtDate
        ]	
    });
	var pnlBtmInfo=new Ext.Panel({
	    id:'pnlBtmInfo',
		layout:'table',
		frame:true,
        items:[
        	pnlDoc,
        	pnlDate
        ]	
    }); 

	var pnlRM=new Ext.Panel({
	    id:'pnlRM',
		layout:'form',
		width:550,
		//frame:true,
        items:[
        	pnlOPSort,
        	pnlBtmInfo
        ]	
    }); 


	var pnlMiddle=new Ext.Panel({
	    id:'pnlMiddle',
		layout:'table',
		frame:true,
        items:[
        	pnlASADifficulty,
	        pnlRM
        ]	
    }); 

    var btnSubmit=new Ext.Button({
		id:'btnSubmit',
		text:'�ύ',
		handler: function() {
        	btnSubmit_click();
    	}
	});
	var btnParaherf=new Ext.Button({
		id:'btnParaherf',
		text:'�ύ',
		handler: function() {
        	btnParaherf_click();
    	}
	});
    var btnRiskItem=new Ext.Button({
		id:'btnRiskItem',
		text:'���չ���',
		handler: function() {
        	btnRiskItem_click();
    	}
	});
	var btnPrint=new Ext.Button({
		id:'btnPrint',
		text:'��ӡ',
		handler: function() {
        	btnPrint_click();
    	}
	});
	var pnlButton=new Ext.Panel({
	    id:'pnlButton',
		layout:'column',
        buttons:[
	        btnSubmit
	        ,btnRiskItem
	        ,btnPrint
        ]	
    }); 
    

    var pnlTitle=new Ext.Panel({
		id:'pnlTitle',
		frame:true,
        title:CtlocDesc+'�������չ���ּ���',
        width:1000,
        layout:'form',
        items: [
	        pnlTopInfo,
	        pnlOpDifficulty,
	        pnlMiddle,
	        pnlButton
        ],
        renderTo: bd		
	});
	
	//-------------------Button Function------------------------------------------
	
	
    function btnSubmit_click()
	{
		if(confirm("�Ƿ��ύ?"))
		{
			var obj=OPGrid.getSelectionModel().getSelected();
			if  (obj) var OpDifCode=obj.get('OpCode')
			else{alert("�����Ѷ�Ϊ��");return;};
		    //if(OpDifCode){alert("�����Ѷ�Ϊ��");return;} 
			var obj=ASAGrid.getSelectionModel().getSelected();
			if  (obj) var ASACode=obj.get('ASACode');
			else {alert("ASA�ּ�Ϊ��");return;} 
			var obj=OPSortGrid.getSelectionModel().getSelected();
			if  (obj) var OPType=obj.get('OPType');	
			else {alert("��������Ϊ��");return;}
			//Purpose ����/�޸�			
			//alert(EpisodeID+"^"+UserId+"^"+CtlocId+"^"+cmbPreOpName.getValue()+"^"+OpDifCode+"^"+ASACode+"^"+OPType);
			//�ֹ�¼��
			if 	(cmbPreOpName.getValue()==cmbPreOpName.getRawValue()) {var ret=_DHCANRRisk.SaveANRRisk(EpisodeID,UserId,CtlocId,""+"|"+cmbPreOpName.getRawValue(),OpDifCode,ASACode,OPType,"I",anrrDr)}
			else {var ret=_DHCANRRisk.SaveANRRisk(EpisodeID,UserId,CtlocId,cmbPreOpName.getValue()+"|"+cmbPreOpName.getRawValue(),OpDifCode,ASACode,OPType,"I",anrrDr)}
		 	if(ret.split("^")[0]>0)
		 	{
			 	AnrrId=ret.split("^")[0];
			 	AnrcmcDr=ret.split("^")[1];
			 	AnrcmcCode=ret.split("^")[2];			 		 		
			 	//��ת���ڶ�ҳ
			 	//window.close();
			 	var screenWidth = window.screen.width-10;
				var screenHeight = window.screen.height-70;
				//alert(AnrrId+"&AnrcmcDr="+AnrcmcDr);
				var nwin="width="+screenWidth+",height="+screenHeight+",top=0,left=0,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no"
				var lnk="dhcanrcriskitem.csp?AnrrId="+AnrrId+"&AnrcmcDr="+AnrcmcDr;
				window.open(lnk,'_self',nwin)						 
		 	}
		 	else alert(ret)
		}
		else
		{
		}
	}
	function btnRiskItem_click()
	{
		//AnrcmcDr=5,AnrrId=6;
		//alert(AnrcmcDr+"---"+AnrrId)	
		if (AnrrId==""){alert("������������������,��ȷ�ϣ�");return;}
		window.close();
		var screenWidth = window.screen.width-10;
		var screenHeight = window.screen.height-70;
		var nwin="width="+screenWidth+",height="+screenHeight+",top=0,left=0,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no"
		var lnk="dhcanrcriskitem.csp?AnrrId="+AnrrId+"&AnrcmcDr="+AnrcmcDr;
		window.open(lnk,'_self',nwin)
	}
	function btnParaherf_click()
	{
		
	}	
	function GetFilePath()
	{
		var _UDHCANOPArrange=ExtTool.StaticServerObject('web.UDHCANOPArrange');
		var path=_UDHCANOPArrange.GetPath();
		return path;
	}
	function isCon(arr, val)
	{
		for(var i=0; i<5; i++)
		{
			for(var j=0;j<4;j++)
			{
				if(arr[i][j] == val)
				return arr[i][j+1];
			}
		}
		return "";
	}
	function isCon2(arr, val)
	{
		for(var i=0; i<3; i++)
		{
			for(var j=0;j<4;j++)
			{
				if(arr[i][j] == val)
				return arr[i][j+1];
			}
		}
		return "";
	}
	//��ӡ�����ּ�(��ҳ)
	function btnPrint_click()	
	{
		var prnType="";
		var name,fileName,path,operStat,printTitle,operNum;
		var xlsExcel,xlsBook,xlsSheet;
		var row=3;
		var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
		var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
		path=GetFilePath();
		fileName=path+"\\\\"+"SSFXGL.xls";
		xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Add(fileName) ;
		xlsSheet = xlsBook.ActiveSheet;		
		var printPatInfo=patInfo.split("^");	
		xlsSheet.cells(1,1)=Locdes+"�������չ���ּ�";
		xlsSheet.cells(2,1)="�������չ���"+AnrmcDesc+"��";
		xlsSheet.cells(3,1)="����";
		xlsSheet.cells(3,2)=printPatInfo[4];
		xlsSheet.cells(3,3)="������";
		xlsSheet.cells(3,4)=printPatInfo[12];
		xlsSheet.cells(3,5)="�Ա�";
		xlsSheet.cells(3,6)=printPatInfo[3];
		xlsSheet.cells(3,7)="����";
		xlsSheet.cells(3,8)=printPatInfo[7];		
		xlsSheet.cells(4,1)="��ǰ���";
		xlsSheet.cells(4,2)=printPatInfo[13];
		xlsSheet.cells(5,1)="������������";
		xlsSheet.cells(5,2)=OperationDesc;
		xlsSheet.cells(6,1)="�����Ѷ�";
		xlsSheet.cells(6,2)=OperDiffDesc;
		xlsSheet.cells(6,3)=isCon(OPData,OperDiffDesc);		
		xlsSheet.cells(7,1)="����ASA�ּ�";
		xlsSheet.cells(7,2)=AsaDesc;
		xlsSheet.cells(7,3)=isCon(ASAData,AsaDesc+"��");;
		xlsSheet.cells(8,1)="�������ռ���";
		xlsSheet.cells(8,2)=AnrcrcDesc;
		xlsSheet.cells(9,1)="��������";
		xlsSheet.cells(9,2)=OpTypeDesc;
		xlsSheet.cells(9,3)=isCon2(OPSortData,OpTypeDesc+"����");
		xlsSheet.cells(10,5)="סԺҽ��";		
		xlsSheet.cells(10,6)=CrtDocDrDesc;
		xlsSheet.cells(10,7)="�ύ����";		
		xlsSheet.cells(10,8)=ANCdate;				
		//xlsExcel.Visible = true;
		//xlsSheet.PrintPreview;		
		xlsSheet.PrintOut();
		xlsSheet = null;
		xlsBook.Close(savechanges=false)
		xlsBook = null;
		xlsExcel.Quit();
		xlsExcel = null;		
	}	 	
	
	var _DHCANRRisk=ExtTool.StaticServerObject('web.DHCANRRisk');
    var _DHCANOPCom=ExtTool.StaticServerObject('web.DHCANOPCom');
	var patInfo=_DHCANOPCom.PatInfo("^"+EpisodeID,"");
	var AnrrId="",AnrcmcDr=""
	var OperationDr="",OperationDesc="",OperDiffDr="",OperDiffDesc="",AsaDr="",AsaDesc="",AnrcrcDr="",OpType="",OpTypeDesc="",AnrStatus=""
    
    LoadPatientInfo();
    if (anrrDr!="") //�޸�
    {
    	LoadANRRisk();
		SetElementValue();
    }

	function LoadANRRisk()
	{
		var ret=_DHCANRRisk.LoadANRRisk(EpisodeID,CtlocId,"",anrrDr);
		//alert(ret)
		
		if(ret!="")
		{
			//anrrDr_$c(1)_OperationDr_"^"_OperationDesc_$c(1)_OperDiffDr_"^"_OperDiffDesc_$c(1)_AsaDr_"^"_AsaDesc_$c(1)_AnrcrcDr_$c(1)_AnrcmcDr_$c(1)_OpType_"^"_OpTypeDesc
			
			AnrrId=ret.split(String.fromCharCode(1))[0];
			OperationDr=ret.split(String.fromCharCode(1))[1].split("^")[0];
			OperationDesc=ret.split(String.fromCharCode(1))[1].split("^")[1];
			OperDiffDr=ret.split(String.fromCharCode(1))[2].split("^")[0];
			OperDiffDesc=ret.split(String.fromCharCode(1))[2].split("^")[1];
			AsaDr=ret.split(String.fromCharCode(1))[3].split("^")[0];
			AsaDesc=ret.split(String.fromCharCode(1))[3].split("^")[1];			
			AnrcrcDr=ret.split(String.fromCharCode(1))[4].split("^")[0];
			AnrcrcDesc=ret.split(String.fromCharCode(1))[4].split("^")[1];
			AnrcmcDr=ret.split(String.fromCharCode(1))[5].split("^")[0];
			AnrmcDesc=ret.split(String.fromCharCode(1))[5].split("^")[1];
			OpType=ret.split(String.fromCharCode(1))[6].split("^")[0];
			OpTypeDesc=ret.split(String.fromCharCode(1))[6].split("^")[1];
			AnrStatus=ret.split(String.fromCharCode(1))[7].split("^")[0];
			ANCdate=ret.split(String.fromCharCode(1))[8].split("^")[0];
			ANCtime=ret.split(String.fromCharCode(1))[8].split("^")[1];
			LocId=ret.split(String.fromCharCode(1))[9].split("^")[0];
			Locdes=ret.split(String.fromCharCode(1))[9].split("^")[1];
			CrtDocDr=ret.split(String.fromCharCode(1))[10].split("^")[0];
			CrtDocDrDesc=ret.split(String.fromCharCode(1))[10].split("^")[1];		
			if (AnrStatus=="A"){ btnSubmit.hide();}
		}

	}
		
	//---------------------data------------------------------------
	
	
	//alert(patInfo)
	//regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_
	//$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"^"_$g(wardDesc)_"^"_homeAddres_"^"_
	//homeTel_"  "_workTel_"  "_handtel_"^"_$G(DocDes)_"^"_medicareNo_"^"_MRDiagnos_"^"_Nation_"^"_paersonLX_"^"_DrugCell_"^"_$G(birthDate)_"^"_$G(patWordUnit)_"^"_$G(PersonID)_"^"_BloodType_"^"_PAAdmReasonDesc_"^"_AdmDoc_"^"_MainNurse_"^"_admStayDay_"^"_AdmReason_"^"_Complaints
	function LoadPatientInfo()
	{
		var arrPatInfo=patInfo.split("^");			
		txtName.setValue(arrPatInfo[4]);
	    txtMedCareNo.setValue(arrPatInfo[12]);
	    txtGender.setValue(arrPatInfo[3]);
	    txtAge.setValue(arrPatInfo[7]);
		txtPrediag.setValue(arrPatInfo[13]);		
	}
	function SetElementValue()
	{
		if (AnrrId=="")	txtDoc.setValue(UserName);
		else  txtDoc.setValue(CrtDocDrDesc);
		if (AnrrId=="") txtDate.setValue(GuidanceDate);
		else  txtDate.setValue(ANCdate);
		if (AnrrId!="")
		{
			cmbPreOpName.setValue(OperationDr);
			cmbPreOpName.setRawValue(OperationDesc);			
		}	
		cmbASA.setValue(AsaDesc);
		cmbOPSort.setValue(OpTypeDesc);
	
		var asaint=0,diffint=0,sortint=0		
		for(var i=0;i<ASAGrid.getStore().getCount();i++)  //ASA����ּ�
		{
			var obj=ASAGrid.getStore().getAt(i);
			if (obj.get('ASADifficulty')==AsaDesc+"��")
			{
				asaint=i
				//ASAGrid.getSelectionModel().selectRow(2);						
				setTimeout(function(){
				ASAGrid.getSelectionModel().selectRow(asaint);
 				},500);
			}
		}
		for(var j=0;j<OPGrid.getStore().getCount();j++)  //�����Ѷȷּ�
		{
			var obj=OPGrid.getStore().getAt(j);
			if (obj.get('OpDifficulty')==OperDiffDesc)
			{		
				diffint=j	
				setTimeout(function(){
				OPGrid.getSelectionModel().selectRow(diffint);
 				},500);		
			}		  
		 }
		 for(var k=0;k<OPSortGrid.getStore().getCount();k++)  //�������ͷּ�
		{
			var obj=OPSortGrid.getStore().getAt(k);		
			if (obj.get('OPSort')==OpTypeDesc+"����")
			{			
				sortint=k							
				setTimeout(function(){	
				OPSortGrid.getSelectionModel().selectRow(sortint);
 				},500);		
			}		  
		 }
		//alert(index)
		//OPGrid.getSelectionModel().selectRow(1);
		//OpSm.handleMouseDown = Ext.emptyFn;
		//alert(OPGrid.getSelectionModel())
		//OpSm.selectRow(index);
		//OPGrid.getSelectionModel().selectAll();
		
		/*
			var obj=OPGrid.getStore().getAt(i);
			var OpDifficulty=obj.get('OpDifficulty');
			//alert(OperDiffDesc+"--"+OpDifficulty)
			if(OperDiffDesc==OpDifficulty)
			{
				alert(obj.get('OPChecked'))
				obj.set('OPChecked',!obj.get('OPChecked'));
				alert(obj.get('OPChecked'))
				//obj.set('ASAChecked',!obj.get('ASAChecked'));
				//alert(obj.get('OPChecked'))
				//ASAStore.reload();
				//obj.selectRow(i,false)
				//alert(OPGrid.getSelectionModel().selectRow(i))
				//alert(OpDifficulty.selectRow(i))
				//OpSm.selectRow(i,true);  
				//OpDifficulty.selectRow(i)
				//OPGrid.getSelectionModel().selectRow(i);
			}
			*/
	}
	/*
	OPGrid.on('select',function(){
		for(var i=0;i<OPGrid.getStore().getCount();i++)
		{
			
			alert(i)
		}
		
		
	})
	*/

});