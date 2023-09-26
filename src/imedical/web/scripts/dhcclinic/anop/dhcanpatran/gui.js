function InitWinScreen(){
	 var obj = new Object();
	//��������*
	obj.txtPatname = new Ext.form.TextField({
	    id : 'txtPatname'
		,fieldLabel : '����'
		,anchor :'98%'
		,style:'font-size:16px'
	});
	//�ǼǺ�*
	obj.txtMedCareNo = new Ext.form.TextField({
	    id : 'txtMedCareNo'
		,fieldLabel : 'סԺ��'
		,anchor :'98%'
		,style:'font-size:16px'
	});
	//�Ա�*
	obj.txtPatSex = new Ext.form.TextField({
	    id : 'txtPatSex'
		,fieldLabel : '�Ա�'
		,anchor :'90%'
		,style:'font-size:16px'
	});
	//����*
	obj.txtPatAge = new Ext.form.TextField({
	    id : 'txtPatAge'
		,fieldLabel : '����'
		,anchor :'90%'
		,style:'font-size:16px'
	});
	// ���˿���*
	obj.txtPatLoc = new Ext.form.TextField({
	    id : 'txtPatLoc'
		,fieldLabel : '���˿���'
		,anchor :'98%'
		,style:'font-size:16px'
	});
	obj.comopaIdStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comopaIdStore = new Ext.data.Store({
	    proxy : obj.comopaIdStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'opaId'
		},
		[
			{name:'opaIdDesc',mapping:'opaIdDesc'}
		    ,{name:'opaId',mapping:'opaId'}
		    
		])
	});
	obj.comopaId = new Ext.form.ComboBox({
	    id : 'comopaId'
		,store : obj.comopaIdStore
		,minChars : 1
		,displayField : 'opaIdDesc'
		,fieldLabel : '����Id'
		,valueField : 'opaId'
		,editable:false
		,triggerAction : 'all'
		,anchor : '95%'
		,style:'font-size:16px'
	});
	obj.comopaIdStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCOPPatTran';
		    param.QueryName = 'FindopaIdListByAdm';
		    param.Arg1 = EpisodeID
	    	param.ArgCnt = 1;
	    });
	obj.Panel001 = new Ext.Panel({
	    id : 'Panel001'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .21
		,layout : 'form'
		,items : [
			obj.comopaId
		]
	});
	obj.txtopaIdInfoList = new Ext.form.TextArea({
	    id : 'txtopaIdInfoList'
		,fieldLabel : '�����б�'
		,anchor :'95%'
		,style:'font-size:15px'
	});
	obj.Panel002 = new Ext.Panel({
	    id : 'Panel002'
		,buttonAlign : 'center'
		,labelWidth:80
		,columnWidth : .46
		,layout : 'form'
		,items : [
			obj.txtopaIdInfoList
		]
	});
	obj.btnPrint=new Ext.Button({
		id : 'btnPrint'
		,text : '��ӡ'
		,height:27
		,width:50
	});
	obj.Panel003 = new Ext.Panel({
	    id : 'Panel003'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .24
		,layout : 'form'
		,items : [
			obj.btnPrint
		]
	});
	obj.Panel10 = new Ext.Panel({
	    id : 'Panel10'
		,buttonAlign : 'center'
		,labelWidth:80
		,columnWidth : .30
		,layout : 'form'
		,items : [
			obj.txtPatLoc
		]
	});
	obj.Panel11 = new Ext.Panel({
	    id : 'Panel11'
		,buttonAlign : 'center'
		,labelWidth:50
		,columnWidth : .20
		,layout : 'form'
		,items : [
		    obj.txtPatname
		]
	});
	obj.Panel12 = new Ext.Panel({
	    id : 'Panel12'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .20
		,layout : 'form'
		,items : [
		    obj.txtMedCareNo
		]
	});
	obj.Panel13 = new Ext.Panel({
	    id : 'Panel13'
		,buttonAlign : 'center'
		,labelWidth:50
		,columnWidth : .12
		,layout : 'form'
		,items : [
		    obj.txtPatSex
			
		]
	});
	obj.Panel14 = new Ext.Panel({
	    id : 'Panel14'
		,buttonAlign : 'center'
		,labelWidth:50
		,columnWidth : .12
		,layout : 'form'
		,items : [
		    obj.txtPatAge
		]
	});
	obj.admPanel = new Ext.FormPanel({
	    id : 'admPanel'
		,buttonAlign : 'center'
		,labelWidth:100
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		    obj.Panel10
		    ,obj.Panel11
			,obj.Panel12
			,obj.Panel13
			,obj.Panel14
		]
	});
	obj.opaIdPanel = new Ext.FormPanel({
	    id : 'opaIdPanel'
		,buttonAlign : 'center'
		,labelWidth:100
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		   obj.Panel001
		   ,obj.Panel002
		   ,obj.Panel003
		]
	});
	
	obj.admInfPanel = new Ext.Panel({
	    id : 'admInfPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,title : '������Ϣ'
		,region : 'north'
		,layout : 'form'
		,height : 130
		,frame :true
		,items : [
			obj.admPanel
			,obj.opaIdPanel
		]
	});
	obj.txtPatBP = new Ext.form.TextField({
	    id : 'txtPatBP'
		,fieldLabel : '<span style="color:red;">��������:</span>BP'
		,width:65
		,style:'font-size:16px'
		,listeners: {
    	 	render: function(obj) {
    	 	var font=document.createElement("font");
			font.setAttribute("color","red");
			var redStar=document.createTextNode('mmHg');
			font.appendChild(redStar);    
			obj.el.dom.parentNode.appendChild(font);
    								}
    				}
	});
	obj.txtPatP = new Ext.form.TextField({
	    id : 'txtPatP'
		,fieldLabel : 'P'
		,width:60
		,style:'font-size:16px'
		,listeners: {
    	 	render: function(obj) {
    	 	var font=document.createElement("font");
			font.setAttribute("color","red");
			var redStar=document.createTextNode('��/��');
			font.appendChild(redStar);    
			obj.el.dom.parentNode.appendChild(font);
    								}
    				}
	});
	obj.txtPatT = new Ext.form.TextField({
	    id : 'txtPatT'
		,fieldLabel : 'T'
		,width:60
		,style:'font-size:16px'
		,listeners: {
    	 	render: function(obj) {
    	 	var font=document.createElement("font");
			font.setAttribute("color","red");
			var redStar=document.createTextNode('��');
			font.appendChild(redStar);    
			obj.el.dom.parentNode.appendChild(font);
    								}
    				}
	});
	obj.Panel201 = new Ext.Panel({
	    id : 'Panel201'
		,buttonAlign : 'center'
		,labelWidth:100
		,columnWidth : .25
		,layout : 'form'
		,items : [
		    obj.txtPatBP
		]
	});
	obj.Panel202 = new Ext.Panel({
	    id : 'Panel202'
		,buttonAlign : 'center'
		,labelWidth:30
		,columnWidth : .20
		,layout : 'form'
		,items : [
		    obj.txtPatP
		]
	});
	obj.Panel203 = new Ext.Panel({
	    id : 'Panel203'
		,buttonAlign : 'center'
		,labelWidth:30
		,columnWidth : .20
		,layout : 'form'
		,items : [
		    obj.txtPatT
		]
	});
	obj.Panel20 = new Ext.FormPanel({
	    id : 'Panel20'
		,buttonAlign : 'center'
		,labelWidth:100
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		    obj.Panel201
		    ,obj.Panel202
		    ,obj.Panel203
		]
	});
	obj.chkconsciousness = new Ext.form.RadioGroup({
	    id : 'chkconsciousness'
		,fieldLabel : '<span style="color:red;">��ʶ״̬</span>'
		,labelWidth:10
		,items: [
			{ boxLabel: '<span style="font-size:16px;">����</span>', name: "consciousness", inputValue: "1" },
            { boxLabel: '<span style="font-size:16px;">��˯</span>', name: "consciousness", inputValue: "2" },
            { boxLabel: '<span style="font-size:16px;">ģ��</span>', name: "consciousness", inputValue: "3" },
            { boxLabel: '<span style="font-size:16px;">��˯</span>', name: "consciousness", inputValue: "4" },
            { boxLabel: '<span style="font-size:16px;">����</span>', name: "consciousness", inputValue: "5" },
            { boxLabel: '<span style="font-size:16px;">��</span>', name: "consciousness", inputValue: "6" }
                 ]
	});
	obj.chkskin = new Ext.form.RadioGroup({
	    id : 'chkskin'
		,fieldLabel : '<span style="color:red;">Ƥ�����</span>'
		,labelWidth:40
		,items: [
			{ boxLabel: '<span style="font-size:16px;">����</span>', name: "skin", inputValue: "N" },
            { boxLabel: '<span style="font-size:16px;">ѹ��</span>', name: "skin", inputValue: "Y" }
            
                 ]
	});
	obj.txtskin = new Ext.form.TextField({
	    id : 'txtskin'
		,fieldLabel : '<span style="color:red;">�������</span>'
		,anchor :'98%'
		,style:'font-size:16px'
	});
	obj.Panel30 = new Ext.Panel({
	    id : 'Panel30'
		,buttonAlign : 'center'
		,labelWidth:80
		,columnWidth : .10
		,layout : 'form'
		,items : [
			obj.chkconsciousness
		]
	});
	obj.Panel401 = new Ext.Panel({
	    id : 'Panel401'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.chkskin
		]
	});
	obj.Panel402 = new Ext.Panel({
	    id : 'Panel402'
		,buttonAlign : 'center'
		,labelWidth:80
		,columnWidth : .50
		,layout : 'form'
		,items : [
			obj.txtskin
		]
	});
	obj.Panel40 = new Ext.FormPanel({
	    id : 'Panel40'
		,buttonAlign : 'center'
		,labelWidth:100
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		    obj.Panel401
		    ,obj.Panel402
		   
		]
	});
	obj.chkIsTube = new Ext.form.RadioGroup({
	    id : 'chkIsTube'
		,fieldLabel : '<span style="color:red;">θ��</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>', name: "IsTube", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>', name: "IsTube", inputValue: "Y" }
            
                 ]
	});
	obj.Panel501 = new Ext.Panel({
	    id : 'Panel501'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.chkIsTube
		]
	});
	obj.chkIsinfusion = new Ext.form.RadioGroup({
	    id : 'chkIsinfusion'
		,fieldLabel : '<span style="color:red;">��Һ</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "Isinfusion", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "Isinfusion", inputValue: "Y" }
            
                 ]
	});
	obj.Panel502 = new Ext.Panel({
	    id : 'Panel502'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.chkIsinfusion
		]
	});
	obj.chkIsCatheter = new Ext.form.RadioGroup({
	    id : 'chkIsCatheter'
		,fieldLabel : '<span style="color:red;">���</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "IsCatheter", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "IsCatheter", inputValue: "Y" }
            
                 ]
	});
	obj.Panel503 = new Ext.Panel({
	    id : 'Panel503'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.chkIsCatheter
		]
	});
	obj.Panel50 = new Ext.FormPanel({
	    id : 'Panel50'
		,buttonAlign : 'center'
		,labelWidth:100
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		    obj.Panel501
		    ,obj.Panel502
			,obj.Panel503
		]
	});
	obj.chkIsTracintubation = new Ext.form.RadioGroup({
	    id : 'chkIsTracintubation'
		,fieldLabel : '<span style="color:red;">���ܲ��</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "IsTracintubation", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "IsTracintubation", inputValue: "Y" }
            
                 ]
	});
	obj.Panel601 = new Ext.Panel({
	    id : 'Panel601'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.chkIsTracintubation
		]
	});
	obj.chkIsOxygentube = new Ext.form.RadioGroup({
	    id : 'chkIsOxygentube'
		,fieldLabel : '<span style="color:red;">������</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "IsOxygentube", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "IsOxygentube", inputValue: "Y" }
            
                 ]
	});
	obj.Panel602 = new Ext.Panel({
	    id : 'Panel602'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.chkIsOxygentube
		]
	});
	obj.chkIsDrainagetube = new Ext.form.RadioGroup({
	    id : 'chkIsDrainagetube'
		,fieldLabel : '<span style="color:red;">������</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "IsDrainagetube", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "IsDrainagetube", inputValue: "Y" }
            
                 ]
	});
	obj.Panel603 = new Ext.Panel({
	    id : 'Panel603'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.chkIsDrainagetube
		]
	});
	obj.Panel60Num = new Ext.form.NumberField({
	    id : 'Panel60Num'
		,fieldLabel : '<span style="color:red;">����</span>'
		,anchor :'98%'
		,allowDecimals: false
		,style:'font-size:16px'
	});
	obj.Panel604 = new Ext.Panel({
	    id : 'Panel604'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .15
		,layout : 'form'
		,items : [
			obj.Panel60Num
		]
	});
	obj.Panel60 = new Ext.FormPanel({
	    id : 'Panel60'
		,buttonAlign : 'center'
		,labelWidth:100
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		    obj.Panel601
		    ,obj.Panel602
			,obj.Panel603
			,obj.Panel604
		]
	});
	obj.chkIsCase = new Ext.form.RadioGroup({
	    id : 'chkIsCase'
		,fieldLabel : '<span style="color:red;">����</span>'
		,labelWidth:60
		,items: [
			
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "IsCase", inputValue: "Y" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "IsCase", inputValue: "N" }
                 ]
	});
	obj.Panel701 = new Ext.Panel({
	    id : 'Panel701'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.chkIsCase
		]
	});
		obj.chkIsTakemedicine = new Ext.form.RadioGroup({
	    id : 'chkIsTakemedicine'
		,fieldLabel : '<span style="color:red;">���д�ҩ</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "IsTakemedicine", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "IsTakemedicine", inputValue: "Y" }
            
                 ]
	});
	obj.Panel702 = new Ext.Panel({
	    id : 'Panel702'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.chkIsTakemedicine
		]
	});
	obj.Panel70Num = new Ext.form.NumberField({
	    id : 'Panel70Num'
		,fieldLabel : '<span style="color:red;">����</span>'
		,anchor :'98%'
		,allowDecimals: false
		,style:'font-size:16px'
	});
	obj.Panel703 = new Ext.Panel({
	    id : 'Panel703'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .15
		,layout : 'form'
		,items : [
			obj.Panel70Num
		]
	});
	obj.PaneXlightNum = new Ext.form.NumberField({
	    id : 'PaneXlightNum'
		,fieldLabel : '<span style="color:red;">X��Ƭ����</span>'
		,anchor :'98%'
		,allowDecimals: false
		,style:'font-size:16px'
	});
	obj.Panel704 = new Ext.Panel({
	    id : 'Panel704'
		,buttonAlign : 'center'
		,labelWidth:120
		,columnWidth : .20
		,layout : 'form'
		,items : [
			obj.PaneXlightNum
		]
	});
	obj.Panel70 = new Ext.FormPanel({
	    id : 'Panel70'
		,buttonAlign : 'center'
		,labelWidth:100
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		    obj.Panel701
		    ,obj.Panel702
			,obj.Panel703
			,obj.Panel704
		]
	});
	obj.txtwardqt = new Ext.form.TextArea({
	    id : 'txtwardqt'
		,anchor :'95%'
		,fieldLabel : '<span style="color:red;">����</span>'
		,style:'font-size:16px'
	});
	obj.Panel80 = new Ext.Panel({
	    id : 'Panel80'
		,buttonAlign : 'left'
		,labelWidth:75
		,columnWidth : .8
		,layout : 'form'
		,items : [
			obj.txtwardqt
		]
	});
	obj.wardfPanel8 = new Ext.form.FormPanel({
		id : 'wardfPanel8'
		,buttonAlign : 'center'
		,labelWidth : 100
		//,height : 60
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.Panel80
		]
	});
	obj.wPanel1 = new Ext.Panel({
	    id : 'wPanel1'
		,layout : 'form'
		,frame : true
		,items : [
			obj.Panel20
		    ,obj.Panel30
		    ,obj.Panel40
		    ,obj.Panel50
		    ,obj.Panel60
		    ,obj.Panel70
		    ,obj.wardfPanel8
		]
	});
	obj.txtOperator = new Ext.form.TextField({
	    id : 'txtOperator'
		,fieldLabel : '������'
		,anchor :'98%'
		,disabled:true
		,style:'font-size:16px'
	});
	obj.txtOperatortime = new Ext.form.TextField({
	    id : 'txtOperatortime'
		,fieldLabel : '����ʱ��'
		,anchor :'98%'
		,disabled:true
		,style:'font-size:16px'
	});
	obj.Panel01 = new Ext.Panel({
	    id : 'Panel01'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .27
		,layout : 'form'
		,items : [
			obj.txtOperator
			,obj.txtOperatortime
		]
	});
	obj.txtTransitman = new Ext.form.TextField({
	    id : 'txtTransitman'
		,fieldLabel : 'ת����'
		,anchor :'98%'
		,style:'font-size:16px'
	});
	obj.txtAuditTime = new Ext.form.TextField({
	    id : 'txtAuditTime'
		,fieldLabel : '���ʱ��'
		,anchor :'98%'
		,disabled:true
		,style:'font-size:16px'
	});
	obj.Panel02 = new Ext.Panel({
	    id : 'Panel02'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .27
		,layout : 'form'
		,items : [
			obj.txtTransitman
			
		]
	});
	obj.txtHandoverperson = new Ext.form.TextField({
	    id : 'txtHandoverperson'
		,fieldLabel : '������'
		,anchor :'98%'
		,disabled:true
		,style:'font-size:16px'
	});
	
	obj.Panel03 = new Ext.Panel({
	    id : 'Panel03'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .27
		,layout : 'form'
		,items : [
			obj.txtHandoverperson
			,obj.txtAuditTime
		]
	});
	obj.wPanel2 = new Ext.form.FormPanel({
	    id : 'wPanel2'
		,buttonAlign : 'center'
		,labelWidth : 80
		,height : 70
		,labelAlign : 'right'
		,layout : 'column'
		,frame : true
		,items : [
		     obj.Panel01
		    ,obj.Panel02
		    ,obj.Panel03
		]
	});
	obj.btntempSave=new Ext.Button({
		id : 'btntempSave'
		,text : '��ʱ����'
		,height:28
		,width:80
	});
	obj.btnWardSendSave=new Ext.Button({
		id : 'btnWardSendSave'
		,text : '��������ȷ��'
		,height:28
		,width:80
	});
	obj.fPanel3 = new Ext.form.FormPanel({
	    id : 'fPanel3'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'column'
		,height : 40
		//,frame : true
		,items : [
			obj.btntempSave
		    ,obj.btnWardSendSave
		]
	});
	obj.wPanel3 = new Ext.Panel({
	    id : 'wPanel3'
		,buttonAlign : 'center'
		,autoScroll : true
		,region : 'south'
		,layout : 'form'
		,frame : true
		,items : [
			 obj.fPanel3
		]
	});
	obj.txtwardReq = new Ext.form.TextArea({
	    id : 'txtwardReq'
		,anchor :'95%'
		,fieldLabel : '<span style="color:red;">������ע</span>'
		,autoHeight : true
		,style:'font-size:16px'
	});
	
	obj.fPanel10 = new Ext.Panel({
	    id : 'fPanel10'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .60
		,layout : 'form'
		,items : [
			obj.txtwardReq
		]
	});
	obj.btnOpToWardSave=new Ext.Button({
		id : 'btnOpToWardSave'
		,text : '�����ҽ������'
		,height:28
		,width:80
		,hidden:true
	});
	obj.btnPACUToWardSave=new Ext.Button({
		id : 'btnPACUToWardSave'
		,text : '�ָ��ҽ������'
		,height:28
		,width:80
		,hidden:true
	});
	obj.fPanel11 = new Ext.Panel({
	    id : 'fPanel11'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.btnOpToWardSave
			,obj.btnPACUToWardSave
		]
	});
	
	obj.wPanel4 = new Ext.form.FormPanel({
	    id : 'wPanel4'
		,buttonAlign : 'center'
		,title : '���˻ط���д'
		,labelWidth : 100
		,height : 100
		,labelAlign : 'right'
		,layout : 'column'
		,frame : true
		,items : [
		     obj.fPanel10
		    ,obj.fPanel11
		]
	});
	obj.wardPanel = new Ext.Panel({
	    id : 'wardPanel'
		,buttonAlign : 'center'
		,title : '������д��Ŀ'
		,layout : 'form'
		,frame : true
		,items : [
			 obj.wPanel1
			 ,obj.wPanel2
			 ,obj.wPanel3
			 ,obj.wPanel4
		]
		
	});
	obj.chkPatientTo = new Ext.form.RadioGroup({
	    id : 'chkPatientTo'
		,fieldLabel : '<span style="color:red;">����ȥ��</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">PACU</span>', name: "PatientTo", inputValue: "1"},
            { boxLabel:'<span style="font-size:16px;">����</span>', name: "PatientTo", inputValue: "2" },
            { boxLabel:'<span style="font-size:16px;">ICU</span>', name: "PatientTo", inputValue: "3" }
            
                 ]
	});
	obj.Panel101 = new Ext.Panel({
	    id : 'Panel101'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .50
		,layout : 'form'
		,items : [
			obj.chkPatientTo
		]
	});
	obj.btnInRoomSave=new Ext.Button({
		id : 'btnInRoomSave'
		,text : '���ҽ������ȷ��'
		,height:27
		,width:90
	});
	obj.Panel102 = new Ext.Panel({
	    id : 'Panel102'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .50
		,layout : 'form'
		,items : [
			obj.btnInRoomSave
		]
	});
	obj.opfPanel1 = new Ext.form.FormPanel({
		id : 'opfPanel1'
		,buttonAlign : 'center'
		,labelWidth : 100
		//,height : 60
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.Panel101
			,obj.Panel102
		]
	});
	obj.chkopconsciousness = new Ext.form.RadioGroup({
	    id : 'chkopconsciousness'
		,fieldLabel : '<span style="color:red;">��ʶ״̬</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">����</span>' , name: "opconsciousness", inputValue: "1" },
            { boxLabel:'<span style="font-size:16px;">��˯</span>' , name: "opconsciousness", inputValue: "2" },
            { boxLabel:'<span style="font-size:16px;">ģ��</span>' , name: "opconsciousness", inputValue: "3" },
            { boxLabel:'<span style="font-size:16px;">��˯</span>' , name: "opconsciousness", inputValue: "4" },
            { boxLabel:'<span style="font-size:16px;">����</span>' , name: "opconsciousness", inputValue: "5" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "opconsciousness", inputValue: "6" }
                 ]
	});
	obj.Panel111 = new Ext.Panel({
	    id : 'Panel111'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .70
		,layout : 'form'
		,items : [
			obj.chkopconsciousness
		]
	});
	obj.opfPanel2 = new Ext.form.FormPanel({
		id : 'opfPanel2'
		,buttonAlign : 'center'
		,labelWidth : 100
		//,height : 60
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.Panel111
		]
	});
	obj.chkopskin = new Ext.form.RadioGroup({
	    id : 'chkopskin'
		,fieldLabel : '<span style="color:red;">Ƥ�����</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">����</span>' , name: "opskin", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">ѹ��</span>' , name: "opskin", inputValue: "Y" }
            
                 ]
	});
	obj.txtopskin = new Ext.form.TextField({
	    id : 'txtopskin'
		,fieldLabel : '<span style="color:red;">�������</span>'
		,anchor :'98%'
		,style:'font-size:16px'
	});
	obj.Panel121 = new Ext.Panel({
	    id : 'Panel121'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .29
		,layout : 'form'
		,items : [
			obj.chkopskin
		]
	});
	obj.Panel122 = new Ext.Panel({
	    id : 'Panel122'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .60
		,layout : 'form'
		,items : [
			obj.txtopskin
		]
	});
	obj.opfPanel3 = new Ext.form.FormPanel({
		id : 'opfPanel3'
		,buttonAlign : 'center'
		,labelWidth : 100
		//,height : 60
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.Panel121
		     ,obj.Panel122
		]
	});
	obj.chkopIsTube = new Ext.form.RadioGroup({
	    id : 'chkopIsTube'
		,fieldLabel : '<span style="color:red;">θ��</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "opIsTube", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "opIsTube", inputValue: "Y" }
            
                 ]
	});
	obj.Panel131 = new Ext.Panel({
	    id : 'Panel131'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .29
		,layout : 'form'
		,items : [
			obj.chkopIsTube
		]
	});
	obj.chkopIsinfusion = new Ext.form.RadioGroup({
	    id : 'chkopIsinfusion'
		,fieldLabel : '<span style="color:red;">��Һ</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "opIsinfusion", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "opIsinfusion", inputValue: "Y" }
            
                 ]
	});
	obj.Panel132 = new Ext.Panel({
	    id : 'Panel132'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .29
		,layout : 'form'
		,items : [
			obj.chkopIsinfusion
		]
	});
	obj.chkopIsCatheter = new Ext.form.RadioGroup({
	    id : 'chkopIsCatheter'
		,fieldLabel : '<span style="color:red;">���</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "opIsCatheter", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "opIsCatheter", inputValue: "Y" }
            
                 ]
	});
	obj.Panel133 = new Ext.Panel({
	    id : 'Panel133'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .29
		,layout : 'form'
		,items : [
			obj.chkopIsCatheter
		]
	});
	obj.opfPanel4 = new Ext.form.FormPanel({
		id : 'opfPanel4'
		,buttonAlign : 'center'
		,labelWidth : 100
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.Panel131
		     ,obj.Panel132
		     ,obj.Panel133
		]
	});
		obj.chkopIsTracintubation = new Ext.form.RadioGroup({
	    id : 'chkopIsTracintubation'
		,fieldLabel : '<span style="color:red;">���ܲ��</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "opIsTracintubation", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "opIsTracintubation", inputValue: "Y" }
            
                 ]
	});
	obj.Panel141 = new Ext.Panel({
	    id : 'Panel141'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .29
		,layout : 'form'
		,items : [
			obj.chkopIsTracintubation
		]
	});
	
	obj.chkopIsDrainagetube = new Ext.form.RadioGroup({
	    id : 'chkopIsDrainagetube'
		,fieldLabel : '<span style="color:red;">������</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "opIsDrainagetube", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "opIsDrainagetube", inputValue: "Y" }
            
                 ]
	});
	obj.Panel142 = new Ext.Panel({
	    id : 'Panel142'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .29
		,layout : 'form'
		,items : [
			obj.chkopIsDrainagetube
		]
	});
	obj.Panel143Num = new Ext.form.NumberField({
	    id : 'Panel143Num'
		,fieldLabel : '<span style="color:red;">����</span>'
		,anchor :'98%'
		,allowDecimals: false
		,style:'font-size:16px'
	});
	obj.Panel143 = new Ext.Panel({
	    id : 'Panel143'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .15
		,layout : 'form'
		,items : [
			obj.Panel143Num
		]
	});
	obj.opfPanel5 = new Ext.form.FormPanel({
		id : 'opfPanel5'
		,buttonAlign : 'center'
		,labelWidth : 100
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.Panel141
		     ,obj.Panel142
		     ,obj.Panel143
		]
	});
	obj.chkopIsCase = new Ext.form.RadioGroup({
	    id : 'chkopIsCase'
		,fieldLabel : '<span style="color:red;">����</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "opIsCase", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "opIsCase", inputValue: "Y" }
            
                 ]
	});
	obj.Panel151 = new Ext.Panel({
	    id : 'Panel151'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .29
		,layout : 'form'
		,items : [
			obj.chkopIsCase
		]
	});
	obj.chkopIsTakemedicine = new Ext.form.RadioGroup({
	    id : 'chkopIsTakemedicine'
		,fieldLabel : '<span style="color:red;">���д�ҩʹ��</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">δ��</span>' , name: "opIsTakemedicine", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">����</span>' , name: "opIsTakemedicine", inputValue: "Y" }
            
                 ]
	});
	obj.Panel152 = new Ext.Panel({
	    id : 'Panel152'
		,buttonAlign : 'center'
		,labelWidth:110
		,columnWidth : .29
		,layout : 'form'
		,items : [
			obj.chkopIsTakemedicine
		]
	});

	obj.PaneopXlightNum = new Ext.form.NumberField({
	    id : 'PaneopXlightNum'
		,fieldLabel : '<span style="color:red;">X��Ƭ����</span>'
		,anchor :'98%'
		,allowDecimals: false
		,style:'font-size:16px'
	});
	obj.Panel153 = new Ext.Panel({
	    id : 'Panel153'
		,buttonAlign : 'center'
		,labelWidth:90
		,columnWidth : .20
		,layout : 'form'
		,items : [
			obj.PaneopXlightNum
		]
	});
	obj.opfPanel6 = new Ext.form.FormPanel({
		id : 'opfPanel6'
		,buttonAlign : 'center'
		,labelWidth : 100
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.Panel151
		     ,obj.Panel152
		     ,obj.Panel153
		]
	});
	obj.txtopqt = new Ext.form.TextArea({
	    id : 'txtopqt'
		,anchor :'95%'
		,fieldLabel : '<span style="color:red;">����</span>'
		,style:'font-size:16px'
	});
	obj.Panel161 = new Ext.Panel({
	    id : 'Panel161'
		,buttonAlign : 'left'
		,labelWidth:75
		,columnWidth : .9
		,layout : 'form'
		,items : [
			obj.txtopqt
		]
	});
	obj.opfPanel7 = new Ext.form.FormPanel({
		id : 'opfPanel7'
		,buttonAlign : 'center'
		,labelWidth : 100
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.Panel161
		]
	});
	obj.pnlOpContent=new Ext.Panel({
	 id:'pnlOpContent'
	,layout : 'form'
	,frame : true
	,items:[
		obj.opfPanel1
		,obj.opfPanel2
		,obj.opfPanel3
		,obj.opfPanel4
		,obj.opfPanel5
		,obj.opfPanel6
		,obj.opfPanel7
	]
	})
	
	obj.txtopOperator = new Ext.form.TextField({
	    id : 'txtopOperator'
		,fieldLabel : '������'
		,anchor :'98%'
		,disabled:true
		,style:'font-size:16px'
	});
	obj.txtopOperatortime = new Ext.form.TextField({
	    id : 'txtopOperatortime'
		,fieldLabel : '����ʱ��'
		,anchor :'98%'
		,disabled:true
		,style:'font-size:16px'
	});
	obj.opTPanel1 = new Ext.Panel({
	    id : 'opTPanel1'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .27
		,layout : 'form'
		,items : [
			obj.txtopOperator
			,obj.txtopOperatortime
		]
	});
	obj.txtopTransitman = new Ext.form.TextField({
	    id : 'txtopTransitman'
		,fieldLabel : 'ת����'
		,anchor :'98%'
		,style:'font-size:16px'
	});
	obj.txtopAuditTime = new Ext.form.TextField({
	    id : 'txtopAuditTime'
		,fieldLabel : '���ʱ��'
		,anchor :'98%'
		,disabled:true
		,style:'font-size:16px'
	});
	obj.opTPanel2 = new Ext.Panel({
	    id : 'opTPanel2'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .27
		,layout : 'form'
		,items : [
			obj.txtopTransitman
			
		]
	});
	obj.txtopHandoverperson = new Ext.form.TextField({
	    id : 'txtopHandoverperson'
		,fieldLabel : '������'
		,anchor :'98%'
		,disabled:true
		,style:'font-size:16px'
	});
	
	obj.opTPanel3 = new Ext.Panel({
	    id : 'opTPanel3'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .27
		,layout : 'form'
		,items : [
			obj.txtopHandoverperson
			,obj.txtopAuditTime
		]
	});
	obj.opOtherPanel1 = new Ext.form.FormPanel({
		id : 'opOtherPanel1'
		,buttonAlign : 'center'
		,labelWidth : 80
		,height : 70
		,labelAlign : 'right'
		,layout : 'column'
		,frame : true
		,items : [ 
			obj.opTPanel1
			,obj.opTPanel2
			,obj.opTPanel3 
		]
	});
	obj.btnoproomSave=new Ext.Button({
		id : 'btnoproomSave'
		,text : '����������ȷ��'
		,height:28
		,width:80
		
	});
	obj.opSPanel1 = new Ext.form.FormPanel({
	    id : 'opSPanel1'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.btnoproomSave
		]
	});
	obj.opOtherPanel2 = new Ext.Panel({
	    id : 'opOtherPanel2'
		,buttonAlign : 'center'
		,autoScroll : true
		,region : 'south'
		,layout : 'form'
		,frame : true
		,items : [
			 obj.opSPanel1
		]
	});
	obj.opPanel = new Ext.Panel({
	    id : 'opPanel'
		,buttonAlign : 'center'
		,title : '��������д��Ŀ'
		,layout : 'form'
		,frame :true
		,items : [
			obj.pnlOpContent
			,obj.opOtherPanel1
			,obj.opOtherPanel2
		]
	});
		obj.chkpacuPatientTo = new Ext.form.RadioGroup({
	    id : 'chkpacuPatientTo'
		,fieldLabel : '<span style="color:red;">����ȥ��</span>'
		,labelWidth:90
		,items: [
			{ boxLabel:'<span style="font-size:16px;">����</span>' , name: "pacuPatientTo", inputValue: "1" },
            { boxLabel:'<span style="font-size:16px;">ICU</span>' , name: "pacuPatientTo", inputValue: "2" },
            { boxLabel:'<span style="font-size:16px;">����</span>' , name: "pacuPatientTo", inputValue: "3" }
            
                 ]
	});
	obj.pacuPanel101 = new Ext.Panel({
	    id : 'pacuPanel101'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .50
		,layout : 'form'
		,items : [
			obj.chkpacuPatientTo
		]
	});
	obj.btnLepatSave=new Ext.Button({
		id : 'btnLepatSave'
		,text : '���ϲ��˽���ȷ��'
		,height:27
		,width:90
	});
	obj.pacuPanel102 = new Ext.Panel({
	    id : 'pacuPanel102'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .50
		,layout : 'form'
		,items : [
			obj.btnLepatSave
		]
	});
	obj.pacufPanel1 = new Ext.form.FormPanel({
		id : 'pacufPanel1'
		,buttonAlign : 'center'
		,labelWidth : 100
		//,height : 60
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.pacuPanel101
			,obj.pacuPanel102
		]
	});
	obj.txtpacuBP = new Ext.form.TextField({
	    id : 'txtpacuBP'
		,fieldLabel : '<span style="color:red;">��������:</span>BP'
		,width:65
		,style:'font-size:16px'
		,listeners: {
    	 	render: function(obj) {
    	 	var font=document.createElement("font");
			font.setAttribute("color","red");
			var redStar=document.createTextNode('mmHg');
			font.appendChild(redStar);    
			obj.el.dom.parentNode.appendChild(font);
    								}
    				}
	});
	obj.pacuPanel111 = new Ext.Panel({
	    id : 'pacuPanel111'
		,buttonAlign : 'center'
		,labelWidth:100
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.txtpacuBP
		]
	});
	obj.txtpacuP = new Ext.form.TextField({
	    id : 'txtpacuP'
		,fieldLabel : 'P'
		,width:60
		,style:'font-size:16px'
		,listeners: {
    	 	render: function(obj) {
    	 	var font=document.createElement("font");
			font.setAttribute("color","red");
			var redStar=document.createTextNode('��/��');
			font.appendChild(redStar);    
			obj.el.dom.parentNode.appendChild(font);
    								}
    				}
	});
	obj.pacuPanel112 = new Ext.Panel({
	    id : 'pacuPanel112'
		,buttonAlign : 'center'
		,labelWidth:30
		,columnWidth : .20
		,layout : 'form'
		,items : [
			obj.txtpacuP
		]
	});
	obj.txtpacuR = new Ext.form.TextField({
	    id : 'txtpacuR'
		,fieldLabel : 'R'
		,width:60
		,style:'font-size:16px'
		,listeners: {
    	 	render: function(obj) {
    	 	var font=document.createElement("font");
			font.setAttribute("color","red");
			var redStar=document.createTextNode('��/��');
			font.appendChild(redStar);    
			obj.el.dom.parentNode.appendChild(font);
    								}
    				}
	});
	obj.pacuPanel113 = new Ext.Panel({
	    id : 'pacuPanel113'
		,buttonAlign : 'center'
		,labelWidth:30
		,columnWidth : .20
		,layout : 'form'
		,items : [
			obj.txtpacuR
		]
	});
	obj.txtpacuSaO = new Ext.form.TextField({
	    id : 'txtpacuSaO'
		,fieldLabel : 'SaO'
		,width:60
		,style:'font-size:16px'
		,listeners: {
    	 	render: function(obj) {
    	 	var font=document.createElement("font");
			font.setAttribute("color","red");
			var redStar=document.createTextNode('%');
			font.appendChild(redStar);    
			obj.el.dom.parentNode.appendChild(font);
    								}
    				}
	});
	obj.pacuPanel114 = new Ext.Panel({
	    id : 'pacuPanel114'
		,buttonAlign : 'center'
		,labelWidth:30
		,columnWidth : .20
		,layout : 'form'
		,items : [
			obj.txtpacuSaO
		]
	});
	obj.pacufPanel2 = new Ext.form.FormPanel({
		id : 'pacufPanel2'
		,buttonAlign : 'center'
		,labelWidth : 100
		//,height : 60
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.pacuPanel111
			,obj.pacuPanel112
			,obj.pacuPanel113
			,obj.pacuPanel114
		]
	});
	obj.chkpacuconsciousness = new Ext.form.RadioGroup({
	    id : 'chkpacuconsciousness'
		,fieldLabel : '<span style="color:red;">��ʶ״̬</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">����</span>' , name: "pacuconsciousness", inputValue: "1" },
            { boxLabel:'<span style="font-size:16px;">��˯</span>' , name: "pacuconsciousness", inputValue: "2" },
            { boxLabel:'<span style="font-size:16px;">ģ��</span>' , name: "pacuconsciousness", inputValue: "3" },
            { boxLabel:'<span style="font-size:16px;">��˯</span>' , name: "pacuconsciousness", inputValue: "4" },
            { boxLabel:'<span style="font-size:16px;">����</span>' , name: "pacuconsciousness", inputValue: "5" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "pacuconsciousness", inputValue: "6" }
                 ]
	});
	obj.pacuPanel121 = new Ext.Panel({
	    id : 'pacuPanel121'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .79
		,layout : 'form'
		,items : [
			obj.chkpacuconsciousness
		]
	});
	obj.pacufPanel3 = new Ext.form.FormPanel({
		id : 'pacufPanel3'
		,buttonAlign : 'center'
		,labelWidth : 100
		//,height : 60
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.pacuPanel121
		]
	});
	obj.chkpacuskin = new Ext.form.RadioGroup({
	    id : 'chkpacuskin'
		,fieldLabel : '<span style="color:red;">Ƥ�����</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">����</span>' , name: "pacuskin", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">ѹ��</span>' , name: "pacuskin", inputValue: "Y" }
            
                 ]
	});
	obj.txtpacuskin = new Ext.form.TextField({
	    id : 'txtpacuskin'
		,fieldLabel : '<span style="color:red;">�������</span>'
		,anchor :'98%'
		,style:'font-size:16px'
	});
	obj.pacuPanel131 = new Ext.Panel({
	    id : 'pacuPanel131'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .29
		,layout : 'form'
		,items : [
			obj.chkpacuskin
		]
	});
	obj.pacuPanel132 = new Ext.Panel({
	    id : 'pacuPanel132'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .60
		,layout : 'form'
		,items : [
			obj.txtpacuskin
		]
	});
	obj.pacufPanel4 = new Ext.form.FormPanel({
		id : 'pacufPanel4'
		,buttonAlign : 'center'
		,labelWidth : 100
		//,height : 60
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.pacuPanel131
		     , obj.pacuPanel132
		]
	});
	obj.chkpacuIsTube = new Ext.form.RadioGroup({
	    id : 'chkpacuIsTube'
		,fieldLabel : '<span style="color:red;">θ��</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "pacuIsTube", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "pacuIsTube", inputValue: "Y" }
            
                 ]
	});
	obj.pacuPanel141 = new Ext.Panel({
	    id : 'pacuPanel141'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .29
		,layout : 'form'
		,items : [
			obj.chkpacuIsTube
		]
	});
	obj.chkpacuIsinfusion = new Ext.form.RadioGroup({
	    id : 'chkpacuIsinfusion'
		,fieldLabel : '<span style="color:red;">��Һ</span>'
		,labelWidth:60
		,items: [
			{ boxLabel: '<span style="font-size:16px;">��</span>', name: "pacuIsinfusion", inputValue: "N" },
            { boxLabel: '<span style="font-size:16px;">��</span>', name: "pacuIsinfusion", inputValue: "Y" }
            
                 ]
	});
	obj.pacuPanel142 = new Ext.Panel({
	    id : 'pacuPanel142'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .28
		,layout : 'form'
		,items : [
			obj.chkpacuIsinfusion
		]
	});
	obj.chkpacuIsCatheter = new Ext.form.RadioGroup({
	    id : 'chkpacuIsCatheter'
		,fieldLabel : '<span style="color:red;">���</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "pacuIsCatheter", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "pacuIsCatheter", inputValue: "Y" }
            
                 ]
	});
	obj.pacuPanel143 = new Ext.Panel({
	    id : 'pacuPanel143'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .28
		,layout : 'form'
		,items : [
			obj.chkpacuIsCatheter
		]
	});
	obj.pacufPanel5 = new Ext.form.FormPanel({
		id : 'pacufPanel5'
		,buttonAlign : 'center'
		,labelWidth : 100
		//,height : 60
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.pacuPanel141
		    ,obj.pacuPanel142
		    ,obj.pacuPanel143
		]
	});
	obj.chkpacuIsTracintubation = new Ext.form.RadioGroup({
	    id : 'chkpacuIsTracintubation'
		,fieldLabel : '<span style="color:red;">���ܲ��</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "pacuIsTracintubation", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "pacuIsTracintubation", inputValue: "Y" }
            
                 ]
	});
	obj.pacuPanel151 = new Ext.Panel({
	    id : 'pacuPanel151'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .29
		,layout : 'form'
		,items : [
			obj.chkpacuIsTracintubation
		]
	});
	obj.chkpacuIsOxygentube = new Ext.form.RadioGroup({
	    id : 'chkpacuIsOxygentube'
		,fieldLabel : '<span style="color:red;">������</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "pacuIsOxygentube", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "pacuIsOxygentube", inputValue: "Y" }
            
                 ]
	});
	obj.pacuPanel152 = new Ext.Panel({
	    id : 'pacuPanel152'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .28
		,layout : 'form'
		,items : [
			obj.chkpacuIsOxygentube
		]
	});
	obj.chkpacuIsDrainagetube = new Ext.form.RadioGroup({
	    id : 'chkpacuIsDrainagetube'
		,fieldLabel : '<span style="color:red;">������</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "pacuIsDrainagetube", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "pacuIsDrainagetube", inputValue: "Y" }
            
                 ]
	});
	obj.pacuPanel153 = new Ext.Panel({
	    id : 'pacuPanel153'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .28
		,layout : 'form'
		,items : [
			obj.chkpacuIsDrainagetube
		]
	});
	obj.pacufPanel6Num = new Ext.form.NumberField({
	    id : 'pacufPanel6Num'
		,fieldLabel : '<span style="color:red;">����</span>'
		,anchor :'98%'
		,allowDecimals: false
		,style:'font-size:16px'
	});
	obj.pacuPanel154 = new Ext.Panel({
	    id : 'pacuPanel154'
		,buttonAlign : 'center'
		,labelWidth:50
		,columnWidth : .15
		,layout : 'form'
		,items : [
			obj.pacufPanel6Num
		]
	});
	obj.pacufPanel6 = new Ext.form.FormPanel({
		id : 'pacufPanel6'
		,buttonAlign : 'center'
		,labelWidth : 100
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.pacuPanel151
		    ,obj.pacuPanel152
		    ,obj.pacuPanel153
		    ,obj.pacuPanel154
		]
	});
	obj.chkpacuIsCase = new Ext.form.RadioGroup({
	    id : 'chkpacuIsCase'
		,fieldLabel : '<span style="color:red;">����</span>'
		,labelWidth:60
		,items: [
			{ boxLabel:'<span style="font-size:16px;">��</span>' , name: "pacuIsCase", inputValue: "N" },
            { boxLabel:'<span style="font-size:16px;">��</span>' , name: "pacuIsCase", inputValue: "Y" }
            
                 ]
	});
	obj.pacuPanel161 = new Ext.Panel({
	    id : 'pacuPanel161'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .29
		,layout : 'form'
		,items : [
			obj.chkpacuIsCase
		]
	});
	obj.PanepacuXlightNum = new Ext.form.NumberField({
	    id : 'PanepacuXlightNum'
		,fieldLabel : '<span style="color:red;">X��Ƭ����</span>'
		,anchor :'98%'
		,allowDecimals: false
		,style:'font-size:16px'
	});
	obj.pacuPanel162 = new Ext.Panel({
	    id : 'pacuPanel162'
		,buttonAlign : 'center'
		,labelWidth:90
		,columnWidth : .20
		,layout : 'form'
		,items : [
			obj.PanepacuXlightNum
		]
	});
	obj.pacufPanel7 = new Ext.form.FormPanel({
		id : 'pacufPanel7'
		,buttonAlign : 'center'
		,labelWidth : 100
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.pacuPanel161
		    ,obj.pacuPanel162
		]
	});
	obj.txtpacuqt = new Ext.form.TextArea({
	    id : 'txtpacuqt'
		,anchor :'95%'
		,fieldLabel : '<span style="color:red;">����</span>'
		,style:'font-size:16px'
	});
	obj.pacuPanel171 = new Ext.Panel({
	    id : 'pacuPanel171'
		,buttonAlign : 'left'
		,labelWidth:75
		,columnWidth : .9
		,layout : 'form'
		,items : [
			obj.txtpacuqt
		]
	});
	obj.pacufPanel8 = new Ext.form.FormPanel({
		id : 'pacufPanel8'
		,buttonAlign : 'center'
		,labelWidth : 100
		//,height : 60
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.pacuPanel171
		]
	});
	obj.pnlPACUContent=new Ext.Panel({
	 id:'pnlPACUContent'
	,layout : 'form'
	,frame : true
	,items:[
		obj.pacufPanel1
		,obj.pacufPanel2
		,obj.pacufPanel3
		,obj.pacufPanel4
		,obj.pacufPanel5
		,obj.pacufPanel6
		,obj.pacufPanel7
		,obj.pacufPanel8
	]
	})
	obj.txtpacuOperator = new Ext.form.TextField({
	    id : 'txtpacuOperator'
		,fieldLabel : '������'
		,anchor :'98%'
		,disabled:true
		,style:'font-size:16px'
	});
	obj.txtpacuOperatortime = new Ext.form.TextField({
	    id : 'txtpacuOperatortime'
		,fieldLabel : '����ʱ��'
		,anchor :'98%'
		,disabled:true
		,style:'font-size:16px'
	});
	obj.pacuTPanel1 = new Ext.Panel({
	    id : 'pacuTPanel1'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .27
		,layout : 'form'
		,items : [
			obj.txtpacuOperator
			,obj.txtpacuOperatortime
		]
	});
	obj.txtpacuTransitman = new Ext.form.TextField({
	    id : 'txtpacuTransitman'
		,fieldLabel : 'ת����'
		,anchor :'98%'
		,style:'font-size:16px'
	});
	obj.txtpacuAuditTime = new Ext.form.TextField({
	    id : 'txtpacuAuditTime'
		,fieldLabel : '���ʱ��'
		,anchor :'98%'
		,disabled:true
		,style:'font-size:16px'
	});
	obj.pacuTPanel2 = new Ext.Panel({
	    id : 'pacuTPanel2'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .27
		,layout : 'form'
		,items : [
			obj.txtpacuTransitman
			
		]
	});
	obj.txtpacuHandoverperson = new Ext.form.TextField({
	    id : 'txtpacuHandoverperson'
		,fieldLabel : '������'
		,anchor :'98%'
		,disabled:true
		,style:'font-size:16px'
	});
	
	obj.pacuTPanel3 = new Ext.Panel({
	    id : 'pacuTPanel3'
		,buttonAlign : 'center'
		,labelWidth:75
		,columnWidth : .27
		,layout : 'form'
		,items : [
			obj.txtpacuHandoverperson
			,obj.txtpacuAuditTime
		]
	});
	obj.pacuOtherPanel1 = new Ext.form.FormPanel({
		id : 'pacuOtherPanel1'
		,buttonAlign : 'center'
		,labelWidth : 80
		,height : 70
		,labelAlign : 'right'
		,layout : 'column'
		,frame : true
		,items : [ 
			obj.pacuTPanel1
			,obj.pacuTPanel2
			,obj.pacuTPanel3 
		]
	});
	obj.btnpacuroomSave=new Ext.Button({
		id : 'btnpacuroomSave'
		,text : '�ز�������ȷ��'
		,height:28
		,width:80
	});
	obj.pacuSPanel1 = new Ext.form.FormPanel({
	    id : 'pacuSPanel1'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.btnpacuroomSave
		]
	});
	obj.pacuOtherPanel2 = new Ext.Panel({
	    id : 'pacuOtherPanel2'
		,buttonAlign : 'center'
		,autoScroll : true
		,region : 'south'
		,layout : 'form'
		,frame :true
		,items : [
			 obj.pacuSPanel1
		]
	});
	obj.PACUPanel = new Ext.Panel({
	    id : 'PACUPanel'
		,buttonAlign : 'center'
		,title : 'PACU��д��Ŀ'
		,layout : 'form'
		,frame : true
		,items : [
         	obj.pnlPACUContent
			,obj.pacuOtherPanel1 
			,obj.pacuOtherPanel2
		]
	});
	
	obj.dateFrm1 = new Ext.form.DateField({
		id : 'dateFrm1'
		,value : new Date()
		,format : 'Y-m-d'
		,fieldLabel : '��������'
		,anchor : '95%'
		,style:'font-size:16px'
	});
	obj.timeOper1 = new Ext.form.TimeField({
	    id : 'timeOper1'
		,format : 'H:i'
		,increment : 1
		,fieldLabel : '����ʱ��'
		,anchor : '90%'
		,style:'font-size:16px'
	});
	obj.Operator1 = new Ext.form.TextField({
	    id : 'Operator1'
		,fieldLabel : '������'
		,anchor :'98%'
		,style:'font-size:16px'
	});
	obj.dateFrm2 = new Ext.form.DateField({
		id : 'dateFrm2'
		,value : new Date()
		,format : 'Y-m-d'
		,fieldLabel : '�������'
		,anchor : '95%'
		,style:'font-size:16px'
	});
	obj.timeOper2 = new Ext.form.TimeField({
	    id : 'timeOper2'
		,format : 'H:i'
		,increment : 1
		,fieldLabel : '���ʱ��'
		,anchor : '90%'
		,style:'font-size:16px'
	});
	obj.Handoverperson2 = new Ext.form.TextField({
	    id : 'Handoverperson2'
		,fieldLabel : '������'
		,anchor :'98%'
		,style:'font-size:16px'
	});
	obj.btnWard=new Ext.Button({
		id : 'btnWard'
		,text : '����'
		,height:28
		,width:80
	});
	obj.NurPanel10 = new Ext.Panel({
	    id : 'NurPanel10'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.dateFrm1
			,obj.timeOper1
			,obj.Operator1
		]
	});
	obj.NurPanel11 = new Ext.Panel({
	    id : 'NurPanel11'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.dateFrm2
			,obj.timeOper2
			,obj.Handoverperson2
		]
	});
	obj.NurPanel12 = new Ext.Panel({
	    id : 'NurPanel12'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.btnWard
			
		]
	});
	obj.NurPanel1 = new Ext.form.FormPanel({
	    id : 'NurPanel1'
		,buttonAlign : 'center'
		,title : '������д'
		,labelWidth : 90
		,labelAlign : 'right'
		,region : 'north'
		,layout : 'column'
		,height : 120
		,frame : true
		,items : [
		    obj.NurPanel10
		    ,obj.NurPanel11
		    ,obj.NurPanel12
		    
		]
	});
	obj.dateFrm3 = new Ext.form.DateField({
		id : 'dateFrm3'
		,value : new Date()
		,format : 'Y-m-d'
		,fieldLabel : '��������'
		,anchor : '95%'
		,style:'font-size:16px'
	});
	obj.timeOper3 = new Ext.form.TimeField({
	    id : 'timeOper3'
		,format : 'H:i'
		,increment : 1
		,fieldLabel : '����ʱ��'
		,anchor : '90%'
		,style:'font-size:16px'
	});
	obj.Operator3 = new Ext.form.TextField({
	    id : 'Operator3'
		,fieldLabel : '������'
		,anchor :'95%'
		,style:'font-size:16px'
	});
	obj.dateFrm4 = new Ext.form.DateField({
		id : 'dateFrm4'
		,value : new Date()
		,format : 'Y-m-d'
		,fieldLabel : '�������'
		,anchor : '95%'
		,style:'font-size:16px'
	});
	obj.timeOper4 = new Ext.form.TimeField({
	    id : 'timeOper4'
		,format : 'H:i'
		,increment : 1
		,fieldLabel : '���ʱ��'
		,anchor : '90%'
		,style:'font-size:16px'
	});
	obj.Handoverperson4 = new Ext.form.TextField({
	    id : 'Handoverperson4'
		,fieldLabel : '������'
		,anchor :'98%'
		,style:'font-size:16px'
	});
	obj.btnWard1=new Ext.Button({
		id : 'btnWard1'
		,text : '����'
		,height:28
		,width:80
	});
	obj.NurPanel20 = new Ext.Panel({
	    id : 'NurPanel20'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.dateFrm3
			,obj.timeOper3
			,obj.Operator3
		]
	});
	obj.NurPanel21 = new Ext.Panel({
	    id : 'NurPanel21'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.dateFrm4
			,obj.timeOper4
			,obj.Handoverperson4
		]
	});
	obj.NurPanel22 = new Ext.Panel({
	    id : 'NurPanel22'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.btnWard1
			
		]
	});
	obj.NurPanel2 = new Ext.form.FormPanel({
	    id : 'NurPanel2'
		,buttonAlign : 'center'
		,title : '��������д'
		,labelWidth : 90
		,labelAlign : 'right'
		,region : 'center'
		,layout : 'column'
		,height : 120
		,frame : true
		,items : [
		    obj.NurPanel20
		    ,obj.NurPanel21
		    ,obj.NurPanel22
		    
		]
	});
		obj.dateFrm5 = new Ext.form.DateField({
		id : 'dateFrm5'
		,value : new Date()
		,format : 'Y-m-d'
		,fieldLabel : '��������'
		,anchor : '95%'
		,style:'font-size:16px'
	});
	obj.timeOper5 = new Ext.form.TimeField({
	    id : 'timeOper5'
		,format : 'H:i'
		,increment : 1
		,fieldLabel : '����ʱ��'
		,anchor : '90%'
		,style:'font-size:16px'
	});
	obj.Operator5 = new Ext.form.TextField({
	    id : 'Operator5'
		,fieldLabel : '������'
		,anchor :'98%'
		,style:'font-size:16px'
	});
	obj.dateFrm6 = new Ext.form.DateField({
		id : 'dateFrm6'
		,value : new Date()
		,format : 'Y-m-d'
		,fieldLabel : '�������'
		,anchor : '95%'
		,style:'font-size:16px'
	});
	obj.timeOper6 = new Ext.form.TimeField({
	    id : 'timeOper6'
		,format : 'H:i'
		,increment : 1
		,fieldLabel : '���ʱ��'
		,anchor : '90%'
		,style:'font-size:16px'
	});
	obj.Handoverperson6 = new Ext.form.TextField({
	    id : 'Handoverperson6'
		,fieldLabel : '������'
		,anchor :'98%'
		,style:'font-size:16px'
	});
	obj.btnWard2=new Ext.Button({
		id : 'btnWard2'
		,text : '����'
		,height:28
		,width:80
	});
	obj.NurPanel30 = new Ext.Panel({
	    id : 'NurPanel30'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.dateFrm5
			,obj.timeOper5
			,obj.Operator5
		]
	});
	obj.NurPanel31 = new Ext.Panel({
	    id : 'NurPanel31'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.dateFrm6
			,obj.timeOper6
			,obj.Handoverperson6
		]
	});
	obj.NurPanel32 = new Ext.Panel({
	    id : 'NurPanel32'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.btnWard2
			
		]
	});
	obj.NurPanel3 = new Ext.form.FormPanel({
	    id : 'NurPanel3'
		,buttonAlign : 'center'
		,title : 'PACU��д'
		,labelWidth : 90
		,labelAlign : 'right'
		,region : 'south'
		,layout : 'column'
		,height : 120
		,frame : true
		,items : [
		    obj.NurPanel30
		    ,obj.NurPanel31
		    ,obj.NurPanel32
		    
		]
	});
	obj.NurPanel = new Ext.Panel({
	    id : 'NurPanel'
		,buttonAlign : 'center'
		,title : '��ʿ����д��Ŀ'
		,layout : 'form'
		,frame : true
		,items : [
         	obj.NurPanel1
         	,obj.NurPanel2
			,obj.NurPanel3
		]
	});
	obj.contentTab = new Ext.TabPanel({
	    //renderTo: Ext.getBody()
		 header : true
		,autoScroll:true 
		,deferredRender:false
		,anchor : '95%'
		,activeTab: 0
		,items: [
		     obj.wardPanel
		    ,obj.opPanel
			,obj.PACUPanel
			,obj.NurPanel
			
		]
	});	
	obj.contentPanel = new Ext.Panel({
	    id : 'contentPanel'
		,buttonAlign : 'center'
		,layout:'fit'
		//,height : 450
		,region : 'center'
		,items : [
		   obj.contentTab
		         ]
	});
	obj.hiddenPanel = new Ext.Panel({
	    id : 'hiddenPanel'
	    ,buttonAlign : 'center'
	    ,region : 'south'
	    ,hidden : true
	    ,items:[	
	    ]
    });

	obj.winScreen = new Ext.Viewport({
	    id : 'winScreen'
		,layout : 'border'
		,items : [
		    obj.admInfPanel
		    ,obj.contentPanel
			,obj.hiddenPanel
			     ]
	});
	InitWinScreenEvent(obj);
	obj.btnWardSendSave.on('click',obj.btnWardSendSave_click,obj);//��������ȷ��
	obj.btnoproomSave.on('click',obj.btnoproomSave_click,obj);//����������ȷ��
	obj.btnInRoomSave.on('click',obj.btnInRoomSave_click,obj);//���ҽ������ȷ��
	obj.btnpacuroomSave.on('click',obj.btnpacuroomSave_click,obj);//(PACU)�ز�������ȷ��
	obj.btnLepatSave.on('click',obj.btnLepatSave_click,obj);//(PACU)���ϲ��˽���ȷ��
	obj.btnOpToWardSave.on('click',obj.btnOpToWardSave_click,obj);//(����)�����Ҳ������ȷ��
	obj.btnPACUToWardSave.on('click',obj.btnPACUToWardSave_click,obj);//(����)�ָ��Ҳ������ȷ��
	obj.comopaId.on('select',obj.comopaId_select,obj);
	obj.btntempSave.on('click',obj.btntempSave_click,obj);//��ʱ����
	obj.btnWard.on('click',obj.btnWard_click,obj);//(����)����
	obj.btnWard1.on('click',obj.btnWard1_click,obj);//(������)����
	obj.btnWard2.on('click',obj.btnWard2_click,obj);//PACU)����
	obj.btnPrint.on('click',obj.btnPrint_click,obj);//��ӡ
	obj.LoadEvent(arguments);
	return obj;
	
	
	
	}