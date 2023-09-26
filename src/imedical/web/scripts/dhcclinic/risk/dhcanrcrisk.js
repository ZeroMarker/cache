Ext.onReady(function(){
    Ext.QuickTips.init();
    //alert(EpisodeID);
    if 	(EpisodeID==""){alert("请选中一条就诊病人！");return;}	
    var bd = Ext.getBody();
    

    var txtName=new Ext.form.TextField({
	    id:'txtName',
		fieldLabel:'姓名',
		anchor:'100%',
		readOnly:true	    
    });
    var txtMedCareNo=new Ext.form.TextField({
	    id:'txtMedCareNo',
		fieldLabel:'病案号',
		anchor:'100%',
		readOnly:true    
    });
    var txtGender=new Ext.form.TextField({
	    id:'txtGender',
		fieldLabel:'性别',
		anchor:'100%',
		readOnly:true	    
    });
    var txtAge=new Ext.form.TextField({
	    id:'txtAge',
		fieldLabel:'年龄',
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
		fieldLabel:'术前诊断',
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
		fieldLabel:'全身系统并发症',
		anchor:'100%',
		readOnly:true   
    });  
    var txtOPComplication=new Ext.form.TextField({
	    id:'txtOPComplication',
		fieldLabel:'手术相关并发症',
		anchor:'100%',
		readOnly:true   
    });  
	var pnlComplication=new Ext.Panel({
	    id:'pnlComplication',
		layout:'form',
		//frame:true,
		title:'术后并发症',
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
  
    //------------------------手术难度分级-----------------------------------//
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
	    fieldLabel: '拟行手术名称',	 
		valueField : 'rowid',
	    displayField: 'OPTypeDes',
	    store:cmbPreOpNameStore,
	    minChars : 1,
	    triggerAction : 'all',
	    anchor:'80%',
	    listeners: {  //为Combo添加select事件
			select: function(cmbPreOpName, record, index) {   // 该事件会返回选中的项对应在 store中的 record值. index参数是排列号.
				//alert(record.get('OPCategory'));
				for(var j=0;j<OPGrid.getStore().getCount();j++)  //手术难度分级
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
    if (CtlocId=="36")  //泌尿外科分级
    {
    	var OPData=[['一级手术','尿道扩张术、精索静脉高位结扎术等1级手术',,'1'],
    		['二级手术','包皮环切,膀胱穿刺造瘘、膀胱镜检等2级手术',,'2'],
    		['三级手术','腹腔镜肾囊肿去顶术、腹腔镜肾上腺肿瘤切除术等3级手术',,'3'],
    		['四级手术','前列腺癌近距离治疗术、腹腔镜嗜铬细胞瘤切除术等4级手术',,'4']    		
    	];
    }
    else if (CtlocId=="48")  //口腔科分级
    {
    	var OPData=[['一级手术','简单牙拔除术、脓肿切开术、浅表淋巴结活检术、开发性损伤清创术(小)',,'1'],
    		['二级手术','唇裂二期修复、取钛板术、口腔软组织肿物切除术等',,'2'],
    		['三级手术','气管切开术、颌下腺摘除术、颈部肿物切除术、舌下腺摘除术、颌骨囊肿刮除术、开发性损伤清创(中)',,'3'],
    		['四级手术','腮腺渗液肿物切除、带血管蒂游离皮瓣修复、上下颌骨正畸、颈淋巴清扫等',,'4']    		
    	];
    }
    else
    {
	    var OPData=[['一级手术','大隐静脉剥脱术、简单血管瘤、门诊手术、血管造影',,'1'],
    		['二级手术','复杂血管瘤手术、周围动静脉腔内治疗',,'2'],
    		['三级手术','主动脉、大血管、外围动脉手术、颈动脉内膜剥脱术、大血管腔内治疗',,'3'],
    		['四级手术','复杂的大血管手术或腔内治疗、新式手术',,'4']    		
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
		store:OPStore,//数据存储器  
		//sm:OpSm,//复选框  
		autoHeight:true,
		columns:[
			{header:'手术难度',dataIndex:'OpDifficulty',width:200}, 
			{header:'分级',dataIndex:'OpDifficultyDesc',width:750}
			,OpSm
			,{header:'OpCode',dataIndex:'OpCode',hidden:true}
	    ]
		}); 
	OPStore.load();

	var pnlOpDifficulty=new Ext.Panel({
	    id:'pnlOpDifficulty',
	    title:'手术难度分级',
		layout:'form',
		frame:true,
        items:[
        	cmbPreOpName,
        	OPGrid
        ]	
    }); 
    //------------------------手术难度分级-----------------------------------//
    //------------------------患者麻醉ASA 分级-----------------------------------//
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
	    fieldLabel: '麻醉ASA分级',
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
    var ASAData=[['Ⅰ级','正常健康,除局部病变外,无系统性疾病',,'1'],
    		['Ⅱ级','有轻度或中度系统性疾病',,'2'],
    		['Ⅲ级','有严重系统性疾病,日常活动受限,但未丧失工作能力',,'3'],
    		['Ⅳ级','有严重系统性疾病,已丧失工作能力,威胁生命安全',,'4'],
    		['V级','病情危重,生命难以维持的濒死病人',,'5']
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
		store:ASAStore,//数据存储器  
		autoHeight:true,
		width:400,
		//sm: new Ext.grid.RowSelectionModel({singleSelect:true}), //设置为单行选中模式
		columns:[
			{header:'ASA',dataIndex:'ASADifficulty',width:50}, 
			{header:'分级',dataIndex:'ASADifficultyDesc',width:330},
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
	    title:'ASA分级',
		layout:'form',
		columnWidth:.4,
		frame:true,
        items:[
        	cmbASA,
        	ASAGrid
        ]	
    }); 
    //------------------------患者麻醉ASA 分级-----------------------------------//
    //------------------------手术分类-----------------------------------//
 	var cmbOPSortData=[
		['B','择期']
		,['R','限期']
		,['E','急诊']
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
		,fieldLabel:'手术类型'
		,valueField:'OPTypeCode'
		,triggerAction : 'all'
		,anchor : '80%'
	});   
    var OPSortSm=new Ext.grid.CheckboxSelectionModel({
	    header:'',
	    dataIndex:'OPSortChecked'
	    });  
    var OPSortData=[['择期手术','疾病影响生活质量,预期改善生活质量,择期进行手术',,'B'],
    		['限期手术','疾病威胁器官、肢体或生命,需尽快进行手术',,'R'],
    		['急诊手术','突发疾病威胁器官、肢体或生命,需急诊进行手术',,'E']
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
		store:OPSortStore,//数据存储器  
		autoHeight:true,
		width:530,
		columns:[
			{header:'手术类型',dataIndex:'OPSort',width:100}, 
			{header:'分级',dataIndex:'OPSortDesc',width:410},
			OPSortSm,
			{header:'OPType',dataIndex:'OPType',hidden:true}
		]
		});  
	var pnlOPSort=new Ext.Panel({
	    id:'pnlOPSort',
	    title:'手术分类',
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
    //------------------------手术分类-----------------------------------//


    var txtDoc=new Ext.form.TextField({
	    id:'txtDoc',
		fieldLabel:'填表住院医师',
		anchor:'100%',
		readOnly:true	    
    });
    var txtDate=new Ext.form.TextField({
	    id:'txtDate',
		fieldLabel:'日期',
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
		text:'提交',
		handler: function() {
        	btnSubmit_click();
    	}
	});
	var btnParaherf=new Ext.Button({
		id:'btnParaherf',
		text:'提交',
		handler: function() {
        	btnParaherf_click();
    	}
	});
    var btnRiskItem=new Ext.Button({
		id:'btnRiskItem',
		text:'风险管理',
		handler: function() {
        	btnRiskItem_click();
    	}
	});
	var btnPrint=new Ext.Button({
		id:'btnPrint',
		text:'打印',
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
        title:CtlocDesc+'手术风险管理分级表',
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
		if(confirm("是否提交?"))
		{
			var obj=OPGrid.getSelectionModel().getSelected();
			if  (obj) var OpDifCode=obj.get('OpCode')
			else{alert("手术难度为空");return;};
		    //if(OpDifCode){alert("手术难度为空");return;} 
			var obj=ASAGrid.getSelectionModel().getSelected();
			if  (obj) var ASACode=obj.get('ASACode');
			else {alert("ASA分级为空");return;} 
			var obj=OPSortGrid.getSelectionModel().getSelected();
			if  (obj) var OPType=obj.get('OPType');	
			else {alert("手术分类为空");return;}
			//Purpose 申请/修改			
			//alert(EpisodeID+"^"+UserId+"^"+CtlocId+"^"+cmbPreOpName.getValue()+"^"+OpDifCode+"^"+ASACode+"^"+OPType);
			//手工录入
			if 	(cmbPreOpName.getValue()==cmbPreOpName.getRawValue()) {var ret=_DHCANRRisk.SaveANRRisk(EpisodeID,UserId,CtlocId,""+"|"+cmbPreOpName.getRawValue(),OpDifCode,ASACode,OPType,"I",anrrDr)}
			else {var ret=_DHCANRRisk.SaveANRRisk(EpisodeID,UserId,CtlocId,cmbPreOpName.getValue()+"|"+cmbPreOpName.getRawValue(),OpDifCode,ASACode,OPType,"I",anrrDr)}
		 	if(ret.split("^")[0]>0)
		 	{
			 	AnrrId=ret.split("^")[0];
			 	AnrcmcDr=ret.split("^")[1];
			 	AnrcmcCode=ret.split("^")[2];			 		 		
			 	//跳转到第二页
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
		if (AnrrId==""){alert("不存在手术风险评估,请确认！");return;}
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
	//打印手术分级(首页)
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
		xlsSheet.cells(1,1)=Locdes+"手术风险管理分级";
		xlsSheet.cells(2,1)="手术风险管理"+AnrmcDesc+"级";
		xlsSheet.cells(3,1)="姓名";
		xlsSheet.cells(3,2)=printPatInfo[4];
		xlsSheet.cells(3,3)="病案号";
		xlsSheet.cells(3,4)=printPatInfo[12];
		xlsSheet.cells(3,5)="性别";
		xlsSheet.cells(3,6)=printPatInfo[3];
		xlsSheet.cells(3,7)="年龄";
		xlsSheet.cells(3,8)=printPatInfo[7];		
		xlsSheet.cells(4,1)="术前诊断";
		xlsSheet.cells(4,2)=printPatInfo[13];
		xlsSheet.cells(5,1)="拟行手术名称";
		xlsSheet.cells(5,2)=OperationDesc;
		xlsSheet.cells(6,1)="手术难度";
		xlsSheet.cells(6,2)=OperDiffDesc;
		xlsSheet.cells(6,3)=isCon(OPData,OperDiffDesc);		
		xlsSheet.cells(7,1)="麻醉ASA分级";
		xlsSheet.cells(7,2)=AsaDesc;
		xlsSheet.cells(7,3)=isCon(ASAData,AsaDesc+"级");;
		xlsSheet.cells(8,1)="手术风险级别";
		xlsSheet.cells(8,2)=AnrcrcDesc;
		xlsSheet.cells(9,1)="手术类型";
		xlsSheet.cells(9,2)=OpTypeDesc;
		xlsSheet.cells(9,3)=isCon2(OPSortData,OpTypeDesc+"手术");
		xlsSheet.cells(10,5)="住院医生";		
		xlsSheet.cells(10,6)=CrtDocDrDesc;
		xlsSheet.cells(10,7)="提交日期";		
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
    if (anrrDr!="") //修改
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
		for(var i=0;i<ASAGrid.getStore().getCount();i++)  //ASA麻醉分级
		{
			var obj=ASAGrid.getStore().getAt(i);
			if (obj.get('ASADifficulty')==AsaDesc+"级")
			{
				asaint=i
				//ASAGrid.getSelectionModel().selectRow(2);						
				setTimeout(function(){
				ASAGrid.getSelectionModel().selectRow(asaint);
 				},500);
			}
		}
		for(var j=0;j<OPGrid.getStore().getCount();j++)  //手术难度分级
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
		 for(var k=0;k<OPSortGrid.getStore().getCount();k++)  //手术类型分级
		{
			var obj=OPSortGrid.getStore().getAt(k);		
			if (obj.get('OPSort')==OpTypeDesc+"手术")
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