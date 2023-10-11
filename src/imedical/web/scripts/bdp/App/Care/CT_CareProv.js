/// 名称: 医护人员-主JS	
/// 编写者： 基础数据平台组 、蔡昊哲
/// 编写日期: 2012-6-1
	
	
/**----------------------------------掉用外部JS--------------------------------------**/		

	var htmlurl = "../scripts/bdp/AppHelp/Care/CTCareProv.htm";
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/HtmlHelp.js"> </script>');
	
	//,"->",helphtmlbtn
	//btnRefresh
	
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');

	var ResourceJS = '../scripts/bdp/App/Care/CT_CareProv_Resource.js';//指定科室部分
	var ChartsJS = '../scripts/bdp/App/Care/CT_CareProv_Charts.js';    //FALSH图表部分
	var HospitalJS = '../scripts/bdp/App/Care/CT_CareProv_Hospital.js';//医院关联部分
	var MedUnitJS = '../scripts/bdp/App/Care/CT_CareProv_MedUnit.js';//医疗单元部分
	document.write('<script type="text/javascript" src="'+ResourceJS+'"></script>');
	document.write('<script type="text/javascript" src="'+ChartsJS+'"></script>');
	document.write('<script type="text/javascript" src="'+HospitalJS+'"></script>');
	document.write('<script type="text/javascript" src="'+MedUnitJS+'"></script>');
	
	var CommonJS = '../scripts/bdp/Framework/scripts/PhotoCommon.js';    //证书上传部分
	document.write('<script type="text/javascript" src="'+CommonJS+'"></script>');
	
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
	//document.write("<OBJECT ID='Photo' CLASSID='CLSID:6939ADA2-0045-453B-946F-44F0D6424D8A' CODEBASE='../addins/client/Photo.CAB#version=2,0,0,20'></OBJECT>");

/**----------------------------------掉用外部JS--------------------------------------**/		
	
	
	
Ext.onReady(function() {

    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	SignSrc = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	//医护人员维护
	var SAVE_ACTION_CareProv = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTCareProv";   //保存到医护人员表中
	var STOP_ACTION_CareProv = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassMethod=StopAccount";  //停用医护人员
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassMethod=DeleteData";  //删除医护人员
	var SELECT_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassMethod=SelectSingle";  
	//var ACTION_CareProv = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassQuery=GetList";
	var ACTION_CareProv = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassMethod=GetListPage";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassMethod=OpenData";  //修改时查找数据
	var BindingSpec = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTSpec&pClassQuery=GetDataForCmb1";
    var BindingCarPrvTp = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCarPrvTp&pClassQuery=GetDataForCmb1";
    var BindingCarPrvTpSearch = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCarPrvTp&pClassQuery=GetList"; 
    var BindingCarPrvTpLimit = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassMethod=GetCarPrvTp";
    var BindingLocC="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
    var BindingHosp="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
    var BindingTitle="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTTitle&pClassQuery=GetDataForCmb1";
    
    var UploadPic="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassMethod=UploadPic";
    //var BindingLoc="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetList";

	//关联科室
	//var ACTION_URL_Resource = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.RBResource&pClassQuery=GetList";
	//var ACTION_URL_RelevanceDp = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.RBResource&pClassQuery=RelevanceDp";	
    
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	
    //Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	
		//-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="CT_CareProv"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	
    //初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "CT_CareProv"
	});
		
		/*****************排序*******************/
    Ext.BDP.FunLib.SortTableName = "User.CTCareProv";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    /*****************排序*******************/
     //////////////////////////////日志查看 ////////////////////////////////////////
   // var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
   var logmenu=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLogForOther","GetLinkTable",Ext.BDP.FunLib.SortTableName);
   var btnlog=Ext.BDP.FunLib.GetLogBtn(logmenu) 
   var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName)  
   
   ///日志查看按钮是否显示
   var btnlogflag=Ext.BDP.FunLib.ShowBtnOrNotFun();
   if (btnlogflag==1)
   {
      btnlog.hidden=false;
    }
    else
    {
       btnlog.hidden=true;
    }
    /// 数据生命周期按钮 是否显示
   var btnhislogflag= Ext.BDP.FunLib.ShowLifeBtnOrNotFun();
   if (btnhislogflag==1)
   {
      btnhislog.hidden=false;
    }
    else
    {
       btnhislog.hidden=true;
    }  
   btnhislog.on('click', function(btn,e){    
	   var RowID="",Desc="";
	   if (grid.selModel.hasSelection()) {
	       var rows = grid.getSelectionModel().getSelections(); 
	       RowID=rows[0].get('CTPCPRowId1');
	       Desc=rows[0].get('CTPCPDesc');
	       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
	    }
	    else
	    {
	       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
	    }
  });


    
    Ext.QuickTips.init();												   //--------启用悬浮提示
	Ext.form.Field.prototype.msgTarget = 'qtip';
    
	/**---------------------权限判断 (session['LOGON.GROUPDESC']="Demo Group")  ------------------**/
    var InternalType;
    InternalType="demo";
    /*if(session['LOGON.GROUPDESC']=="Demo Group")
    {
    	InternalType="demo";
    }
    else if(session['LOGON.GROUPDESC']=="医生管理员")
    {
    	InternalType="DOCTOR";
    	BindingCarPrvTp = BindingCarPrvTp+"&InternalType="+InternalType
    }
    else if(session['LOGON.GROUPDESC']=="护士管理员")
    {
    	InternalType="NURSE";
    	BindingCarPrvTp = BindingCarPrvTp+"&InternalType="+InternalType
    }
    else
    {
    	InternalType="Nothing";
    	alert("您没有权限进行医护人员维护，请联系管理员。")
    }*/
    
    /**---------------------权限判断-------------------**/
	
	//多院区医院下拉框	20200520 likefan
	var hospstore=new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1"}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [ 'HOSPRowId', 'HOSPDesc' ])
		})
		var hospComp = new Ext.form.ComboBox({
			id:'_hospComp',
			labelSeparator:"",
			width:250,
			fieldLabel : '医院',
			store : hospstore,
			editable:false,
			queryParam : 'desc',
			triggerAction : 'all',
			forceSelection : true,
			selectOnFocus : false,
			listWidth :250,
			valueField : 'HOSPRowId',
			displayField : 'HOSPDesc'
		});
		hospstore.load({
		       callback: function () {
			       hospComp.setValue(session['LOGON.HOSPID']);   //初始赋值为当前登录科室的院区
			       Ext.getCmp('_hospComp').fireEvent('select',Ext.getCmp('_hospComp'),Ext.getCmp('_hospComp').getStore().getById(session['LOGON.HOSPID']))  //触发select事件
		        },
		        scope: hospstore,
		        add: false
		});
	//医院下拉框选择一条医院记录后执行此函数
	hospComp.on('select',function (){
		grid.getStore().baseParams={			
			Code:Ext.getCmp("CareID").getValue(),
			Desc:Ext.getCmp("CareName").getValue(),
			CarPrvTpDR:Ext.getCmp("CarePrvTp").getValue(),
			ActiveFlag:Ext.getCmp("ActiveFlag").getValue(),
			HICApprovedFlag : Ext.getCmp("CTPCPHICApprovedFlag").getValue(),
			Hospital:hospComp.getValue()
		};
		grid.getStore().load({params:{start:0, limit:pagesize}});
	});

    /**---------医护人员维护表单内容部分------------**/
    /**---------列1------------**/
    
	var Gap = new Ext.BDP.FunLib.Component.TextField({           	//----------CTPCPRowId1 表单主Rowid
		fieldLabel : '  ',
		hidden : true,
		name : 'Gap'
	});
	
	var CTPCPCode = new Ext.BDP.FunLib.Component.TextField({           	 	//----------CTPCPCode  代码
		fieldLabel: "<span style='color:red;'>*</span>代码",
		name: 'CTPCPCode',
		id:'CTPCPCode',
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPCode'),
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPCode')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPCode'),
		blankText: '不能为空',
		allowBlank : false,
		dataIndex:'CTPCPCode',
		validationEvent : 'blur',  
		//enableKeyEvents:true, 
        validator : function(thisText){
            //Ext.Msg.alert(thisText);
	        if(thisText==""){	//当文本框里的内容为空的时候不用此验证
	             return true;
	         }
	        var className =  "web.DHCBL.CT.CTCareProv";	//后台类名称
	        var classMethod = "FormValidate";	//数据重复验证后台函数名	                            
	        var id="";
	        if(wincareprov.title=='修改'){	//如果窗口标题为'修改'则获取rowid
	               var _record = grid.getSelectionModel().getSelected();
	               var id = _record.get('CTPCPRowId1');	//此条数据的rowid
	        }
	        var flag = "";
	        var flag = tkMakeServerCall(className,classMethod,id,thisText);	//用tkMakeServerCall函数实现与后台同步调用交互
	        //Ext.Msg.alert(flag);
	        if(flag == "1"){	//当后台返回数据位"1"时转换为相应的布尔值
	             return false;
	        }else{
	             return true;
	        }
        },
        invalidText : '该代码已经存在',
		listeners : {
				'change' : Ext.BDP.FunLib.Component.ReturnValidResult
		}
		
	});
	var CTPCPOtherName = new Ext.BDP.FunLib.Component.TextField({           //----------CTPCPOtherName 拼音检索码
	    fieldLabel: "<span style='color:red;'>*</span>拼音检索码",
		name: 'CTPCPOtherName',
		id:'CTPCPOtherName',
		blankText: '不能为空',
		allowBlank : false,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPOtherName'),
		style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPOtherName')),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPOtherName'),
		dataIndex:'CTPCPOtherName'
	});
	var CTPCPUnit = new Ext.BDP.FunLib.Component.TextField({                //----------CTPCPUnit 专业资格证书号
	    fieldLabel: '专业资格证书号',
		name: 'CTPCPUnit',
		id:'CTPCPUnit',
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPUnit'),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPUnit'),
		style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPUnit')),
		dataIndex:'CTPCPUnit'
	});
	var CTPCPCarPrvTpDR = new Ext.BDP.Component.form.ComboBox({            //----------CTCPTDesc   医护人员类型  combo		
		fieldLabel: "<span style='color:red;'>*</span>医护人员类型",
		//id:'CTPCPCarPrvTpDR',
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPCarPrvTpDR'),
		blankText: '不能为空',
		allowBlank : false,
		name: 'CTPCPCarPrvTpDR',
		hiddenName:'CTPCPCarPrvTpDR',//不能与id相同
		//triggerAction:'all',//query
		//allQuery:'',
		loadByIdParam : 'rowid',
		forceSelection: true,
		//triggerAction : 'all',
		selectOnFocus:false,
		//hidden : true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPCarPrvTpDR'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPCarPrvTpDR')),
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		listWidth:250,
		valueField:'CTCPTRowId',
		displayField:'CTCPTDesc',
		store:new Ext.data.JsonStore({
			url:BindingCarPrvTp,
			root: 'data',
			totalProperty: 'total',
			autoLoad: true,
			idProperty: 'CTCPTRowId',
			fields:['CTCPTRowId','CTCPTDesc']
		})
		
    });
    
  
    var CTPCPDateActiveFrom = new Ext.BDP.FunLib.Component.DateField({      //----------CTPCPDateActiveFrom  开始日期
        fieldLabel: "<span style='color:red;'>*</span>开始日期",
        id:'CTPCPDateActiveFrom',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPDateActiveFrom'),
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPDateActiveFrom')),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPDateActiveFrom'),
        allowBlank : false,      
        name: 'CTPCPDateActiveFrom',
		format: BDPDateFormat,
		enableKeyEvents : true, 
		listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
		//editable:false
    });
    var CTPCPSurgeon = new Ext.BDP.FunLib.Component.Checkbox({              //----------CTPCPSurgeon  外科医生
    	fieldLabel: '外科医生',
    	id: 'CTPCPSurgeon',
    	readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPSurgeon'),
    	//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPSurgeon'),
    	style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPSurgeon')),
    	name: 'CTPCPSurgeon',
    	dataIndex:'CTPCPSurgeon',
    	inputValue : true?'Y':'N'
    }); 

    var CTPCPHICApproved = new Ext.BDP.FunLib.Component.Checkbox({         //----------CTPCPAnaesthetist  毒麻处方权
        fieldLabel: '毒麻处方权',
        name: 'CTPCPHICApproved',
        id: 'CTPCPHICApproved',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPHICApproved'),
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPHICApproved')),
        dataIndex:'CTPCPHICApproved',
        inputValue : true?'Y':'N',
        listeners : {
			'check' : function() 
			{
				if (!Ext.getCmp("CTPCPHICApproved").getValue())
				{
					Ext.getCmp("CTPCPHICApprovedButton").setDisabled(true);
				}
				else
				{
					Ext.getCmp("CTPCPHICApprovedButton").setDisabled(false);
				}
			}
		}
    });
    var CTPCPMentalFlag = new Ext.BDP.FunLib.Component.Checkbox({
        fieldLabel: '精神类药物处方权',
        name: 'CTPCPMentalFlag',
        id: 'CTPCPMentalFlag',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPMentalFlag'),
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPMentalFlag')),
        dataIndex:'CTPCPMentalFlag',
        inputValue : true?'Y':'N'
    });
    
/*    var myImage = new Ext.BoxComponent({
    autoEl: {
        tag: 'img',
        src: Ext.BDP.FunLib.Path.URL_Img+'test.jpg'
    }
	});*/
	
	var CTPCPHICApprovedButton = new Ext.Button({         //----------CTPCPAnaesthetist  毒麻处方权
		text:'查看证书',
        //fieldLabel: '查看证书',
		iconCls : 'icon-search',
        name: 'CTPCPHICApprovedButton',
        id: 'CTPCPHICApprovedButton',
        hidden : true,
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPHICApprovedButton'),       
		handler: function ShowPic() {
			win_uploadImage.setTitle("毒麻处方权资格证书-" + Ext.getCmp("CTPCPDesc").getValue()+ "-" +Ext.getCmp("CTPCPCode").getValue());  
    		win_uploadImage.imageIndexName = 'Pic1'; 
    		win_uploadImage.show();
    		var CareID = Ext.getCmp("CTPCPCode").getValue()+"mf";
    		//var image = Ext.get('imageBrowse').dom
    		ShowPicByPatientID(CareID,'imageBrowse');
    		
    		/*var image = Ext.get('imageBrowse').dom;    
    		var SignSrc = Ext.BLANK_IMAGE_URL;
    		if (IsExistsFile("ftp://10.160.16.112:21/CarePhoto/"+CareID+".jpg")){
    			SignSrc = "ftp://10.160.16.112:21/CarePhoto/"+CareID +".jpg";
    		}
    		else
    		{
    			SignSrc = "ftp://10.160.16.112:21/CarePhoto/blank.gif1";
    		}		
    		image.src = SignSrc;  	*/
    			
    		Ext.getCmp("HidenPicRowId1").reset();
            Ext.getCmp("HidenPicRowId1").setValue(CareID);
		}
    });
    
    //上传图片类型
var img_reg = /\.([jJ][pP][gG]){1}$|\.([jJ][pP][eE][gG]){1}$|\.([gG][iI][fF]){1}$|\.([pP][nN][gG]){1}$|\.([bB][mM][pP]){1}$/;


var HidenPicRowId1 = new Ext.BDP.FunLib.Component.TextField({ 
    fieldLabel: 'HidenPicRowId1',
	hideLabel:'True',
	hidden : true,
	id: 'HidenPicRowId1',
	name: 'HidenPicRowId1'
});

var win_uploadImage = new Ext.Window({
	layout:'fit',
	width:620,
	closeAction:'hide',
	height:370,
	resizable:false,
	shadow:false,
	modal:true,
	closable:true,
	bodyStyle:'padding: 5 5 5 5',
	animCollapse:true,
	imageIndexName:'',
	items:[{
		xtype:'form',
		id:'image-upload-form',
		frame:true,
		border:false,
		isAdd:false,
		enctype: 'multipart/form-data',
		fileUpload : true,
		layout : 'form',
		items:[HidenPicRowId1,{
		   id : 'file-idx',
	       name : 'file',
	       inputType : "file",
	       fieldLabel : '上传新图片',
	       xtype : 'textfield',
	       blankText:'上传图片不能为空',
	       anchor : '100%'
		},{
		  xtype: 'panel',
		  id : 'imageBrowse',
		  html : "<p style='text-align:center'><img src='ftp://10.160.16.112:21/CarePhoto/blank.gif' width=420 height=210></p>"
		}/*,{
		   xtype : 'box',   
	       id : 'browseImage',
	       fieldLabel : "签名图片",   
	       autoEl : {
	           width : 420,
	           height : 210,
	           tag : 'img',
	            // type : 'image',
	           src :  "",
	           style : 'filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale);',   
	           complete : 'off',   
	           id : 'imageBrowse'
	       }
		}*/
		],
		listeners : {   
	        'render' : function(f) {
	            //
	            this.form.findField('file-idx').on('render', function() {
	                //通過change事件,图片也动态跟踪选择的图片变化
	                Ext.get('file-idx').on('change',
                        function(field, newValue, oldValue) {
	                	//得到选择的图片路径
                        var url = 'file://'+ Ext.get('file-idx').dom.value;
                        //alert("url = " + url);   
                        //是否是规定的图片类型
                        if (img_reg.test(url)) {
                            if (Ext.isIE) {
                            	var obj=document.getElementById('imageBrowse');
                            	obj.innerHTML="<p style='text-align:center'><img SRC='"+url+"' width=420 height=210 ></p>"
                                //var image = Ext.get('imageBrowse').dom;   
                            	//image.src = Ext.BLANK_IMAGE_URL;// 覆盖原来的图片
                            	
                            	//image.filters.item("DXImageTransform.Microsoft.AlphaImageLoader").src = url;   
                            }// 支持FF
                            else {
                                Ext.get('imageBrowse').dom.src = Ext.get('file-idx').dom.files.item(0).getAsDataURL();
                            }
                        }
                    }, this);   
	            }, this);   
	        }   
	    }, 
		buttons:[{
	       text:'关闭',
	       handler:function(){
				win_uploadImage.hide();
	       }
	       },{
	            text:'上传',
	            handler:function() {
		    	    var furl="";
		    	    furl = Ext.getCmp('image-upload-form').form.findField('file').getValue();
					var type = furl.substring(furl.length - 3).toLowerCase();
					if (furl == "" || furl == null) {
						aler('路径不能为空！');
						return;
					}
					if (type != 'jpg' && type != 'bmp' && type != 'gif' && type != 'png') {
						alert('仅支持jpg、bmp、gif、png格式的图片');
						return;
					}
					
					var falg = ChangeStrToPhoto(Ext.getCmp("HidenPicRowId1").getValue(),furl);
		
					if (falg=="1")
					{
						Ext.Msg.show({
						title : '提示',
						msg : '上传成功!',
						icon : Ext.Msg.INFO,
						buttons : Ext.Msg.OK});
					}
					else
					{
						Ext.Msg.show({
						title : '提示',
						msg : '上传失败!',
						icon : Ext.Msg.WARNING,
						buttons : Ext.Msg.OK});
					}
				    
				    
		    	   /*Ext.getCmp('image-upload-form').form.submit({
			  			clienValidation:true,
			  			waitMsg:'正在上传请稍候',
			  			waitTitle:'提示',
			  			url:'UploadPic',
			  			method:'POST',
			  			success:function(form,action){
		    		   		var picName = action.result.data;
		    		   		if(win_uploadImage.imageIndexName!=''){
		    		   			Ext.getCmp(win_uploadImage.imageIndexName).setValue(picName);
		    		   		}
		    		   		//reset form
		    		   		Ext.getCmp('image-upload-form').form.el.dom.reset();
		    		   		if (Ext.isIE) {
		    		   			var i_image = Ext.get('imageBrowse').dom;
		    		   			i_image.src = Ext.BLANK_IMAGE_URL;
		    		   			i_image.filters.item("DXImageTransform.Microsoft.AlphaImageLoader").src = Ext.BLANK_IMAGE_URL;
		    		   		}else{
		    		   			Ext.get('imageBrowse').dom.src = Ext.BLANK_IMAGE_URL;
		    		   		}
		    		   		
		    		   		win_uploadImage.hide();
			    	   	},
			  			failure:function(form,action){
			    	   		Ext.MessageBox.show({title: '失败',msg: '上传失败!',buttons: Ext.MessageBox.OK,icon: Ext.MessageBox.ERROR});
			  		 	}
		    	   })*/
	       		}
	       }
	   ]
}]
});
    
    var CTPCPHICApprovedForm =
    { 
      baseCls : 'x-plain',
      layout : "column",
      items : [{
      	 baseCls : 'x-plain',
         columnWidth : .6,
         layout : "form",
         items : [CTPCPHICApproved]
        }, {
        	baseCls : 'x-plain',
         	columnWidth : .4,
         	layout : "form",
        	items : [CTPCPHICApprovedButton]
        }]
     };
	    
	   
    
    var CTPCPActiveFlag = new Ext.BDP.FunLib.Component.Checkbox({           //----------CTPCPActiveFlag  激活
    	fieldLabel: '激活',
    	id: 'CTPCPActiveFlag',
    	readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPActiveFlag'),
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPActiveFlag')),
    	name: 'CTPCPActiveFlag',
    	dataIndex:'CTPCPActiveFlag',
    	inputValue : true?'Y':'N',
    	checked : true
    });
    /**---------列2------------**/
    var CTPCPDesc = new Ext.BDP.FunLib.Component.TextField({           		//----------CTPCPDesc   姓名
        fieldLabel: "<span style='color:red;'>*</span>姓名",
		name: 'CTPCPDesc',
		id:'CTPCPDesc',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPDesc'),
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPDesc')),
		blankText: '不能为空',
		allowBlank : false,
		dataIndex:'CTPCPDesc',
		listeners : {
			'change' : Ext.BDP.FunLib.Component.ReturnValidResult,
			'blur' : function(){
				Ext.getCmp("CTPCPOtherName").setValue(Pinyin.GetJPU(Ext.getCmp("CTPCPDesc").getValue()))
			}
		 }
    });
    var CTPCPId = new Ext.BDP.FunLib.Component.TextField({           		//----------CTPCPId   标识码
		fieldLabel: '标识码',
		name: 'CTPCPId',
		id:'CTPCPId',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPId'),
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPId')),
		dataIndex:'CTPCPId'					
    });
    var CTPCPTextOne = new Ext.BDP.FunLib.Component.TextField({           	//---------执业证书编码
        fieldLabel: '执业证书编码',
		name: 'CTPCPTextOne',
		id:'CTPCPTextOne',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPTextOne'),
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPTextOne')),
		dataIndex:'CTPCPTextOne'
    });
    var CTPCPTextTwo = new Ext.BDP.FunLib.Component.TextField({           	//----------Text2
        fieldLabel: 'Text2',
		name: 'CTPCPTextTwo',
		id:'CTPCPTextTwo',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPTextTwo'),
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPTextTwo')),
		dataIndex:'CTPCPTextTwo'
    });
    var CTPCPSpecDR = new Ext.BDP.Component.form.ComboBox({           	//----------CTSPCDescCombo   医生专长
		fieldLabel: '医生专长',
		loadByIdParam : 'rowid',
		name: 'CTPCPSpecDR',
		//id:'CTPCPSpecDR',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPSpecDR'),
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPSpecDR')),
		hiddenName:'CTPCPSpecDR',//不能与id相同
		//triggerAction : 'all',
		forceSelection: true,
		selectOnFocus:false,
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		listWidth:250,
		valueField:'CTSPCRowId',
		displayField:'CTSPCDesc',
		store:new Ext.data.JsonStore({
			autoLoad: true,
			url:BindingSpec,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'CTSPCRowId',
			fields:['CTSPCRowId','CTSPCDesc']
		})					   
    });
    var CTPCPAnaesthetist = new Ext.BDP.FunLib.Component.Checkbox({         //----------CTPCPAnaesthetist  麻醉师
        fieldLabel: '麻醉师',
        name: 'CTPCPAnaesthetist',
        id: 'CTPCPAnaesthetist',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPAnaesthetist'),
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPAnaesthetist')),
        dataIndex:'CTPCPAnaesthetist',
        inputValue : true?'Y':'N'
    });
    var CTPCPSpecialistYN = new Ext.BDP.FunLib.Component.Checkbox({         //----------CTPCPAnaesthetist  麻醉师
        fieldLabel: '可以出特需号',
        name: 'CTPCPSpecialistYN',
        id: 'CTPCPSpecialistYN',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPSpecialistYN'),
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPSpecialistYN')),
        dataIndex:'CTPCPSpecialistYN',
        inputValue : true?'Y':'N'
    });
    var CTPCPDateActiveTo = new Ext.BDP.FunLib.Component.DateField({        //----------CTPCPDateActiveTo  结束日期
        fieldLabel: '结束日期',
        name: 'CTPCPDateActiveTo',
        id:'CTPCPDateActiveTo',
        enableKeyEvents : true, 
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPDateActiveTo'),
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPDateActiveTo')),
        //editable:false,
		format: BDPDateFormat ,
		listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
    });
    /*var CTPCPTelO = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPTelO
		//办公电话
		fieldLabel : '办公电话',
		name : 'CTPCPTelO',
		id : 'CTPCPTelO',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelO'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelO')),
		dataIndex : 'CTPCPTelO'
	});
	var CTPCPTelH = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPTelH
		//家庭电话
		fieldLabel : '家庭电话',
		name : 'CTPCPTelH',
		id : 'CTPCPTelH',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelH'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelH')),
		dataIndex : 'CTPCPTelH'
	});
	var CTPCPTelOExt = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPTelOExt
		//电话分机
		fieldLabel : '电话分机',
		name : 'CTPCPTelOExt',
		id : 'CTPCPTelOExt',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelOExt'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelOExt')),
		dataIndex : 'CTPCPTelOExt'
	});
	var CTPCPMobilePhone = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPMobilePhone
		//移动电话
		fieldLabel : '移动电话',
		name : 'CTPCPMobilePhone',
		id : 'CTPCPMobilePhone',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPMobilePhone'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPMobilePhone')),
		dataIndex : 'CTPCPMobilePhone'
	});
	var CTPCPEmail = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPEmail
		//Email
		fieldLabel : 'Email',
		name : 'CTPCPEmail',
		id : 'CTPCPEmail',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPEmail'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPEmail')),
		dataIndex : 'CTPCPEmail'
	});
	var CTPCPFax = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPFax
		//传真
		fieldLabel : '传真',
		name : 'CTPCPFax',
		id : 'CTPCPFax',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPFax'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPFax')),
		dataIndex : 'CTPCPFax'
	});*/
    var CTPCPTitleDR = new Ext.BDP.Component.form.ComboBox({           	//----------CTPCPTitleDR   医护人员职称
		fieldLabel: '医护人员职称',
		loadByIdParam : 'rowid',
		name: 'CTPCPTitleDR',
		//id:'CTPCPTitleDR',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPTitleDR'),
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPTitleDR')),
		hiddenName:'CTPCPTitleDR',//不能与id相同
		//triggerAction : 'all',
		forceSelection: true,
		selectOnFocus:false,
		queryParam : "desc",
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		listWidth:250,
		valueField:'TTLRowId',
		displayField:'TTLDesc',
		store:new Ext.data.JsonStore({
			autoLoad: true,
			url:BindingTitle,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'TTLRowId',
			fields:['TTLRowId','TTLDesc']
		})					   
    });
	
	/**********************************管制药品分类**lkf**2020年4月1日*********************************/
	var _Poisongridds = new Ext.data.Store({
	                proxy : new Ext.data.HttpProxy({
	                	url : "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProvPHCPoison&pClassQuery=GetPHCPoison" }),
	                reader : new Ext.data.JsonReader({
	                            totalProperty : 'total',
	                            root : 'data',
	                            successProperty : 'success'
	                        }, [{name : 'PHCPORowId', mapping : 'PHCPORowId', type : 'string' }, 
	                            {name : 'PHCPODesc',mapping : 'PHCPODesc',type : 'string'},
	                            {name : 'LinkFlag',mapping : 'LinkFlag',type : 'string' }
	                        ]) 
	     });
	     
	   var gridsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : false, checkOnly : false, width : 20,
				listeners:{
					rowdeselect : function( e ,  rowIndex , record  ) 
					{ _PoisongridObj.getStore().getAt(rowIndex).set("LinkFlag","N") },    //当反选一个行时触发
					rowselect : function(  e ,  rowIndex , record ) 
					{ _PoisongridObj.getStore().getAt(rowIndex).set("LinkFlag","Y") }   //当选中一行数据时触发 
				}
		});
		
	    var _PoisongridObj = new Ext.grid.GridPanel({
	                region : 'center',
	                width : 210,
	                height : 210,
	                closable : true,
	                store : _Poisongridds,
	                trackMouseOver : true,
	                columnLines : true, //在列分隔处显示分隔符
	                sm:gridsm,
	                columns : [gridsm,
	                       	{header : '是否关联', width : 80,sortable : true, dataIndex : 'LinkFlag',hidden:true}, 
	                        {header : 'PHCPORowId',width : 80, sortable : true, dataIndex : 'PHCPORowId',hidden:true},
	                        {header : '管制药品分类', width : 160, sortable : true, dataIndex : 'PHCPODesc'}],
	                stripeRows : true ,
	                stateful : true,
	                viewConfig : {
	                    forceFit : true
	                }
	            });
				
	/**********************************关联处方权**lkf**2020年10月19日*********************************/
	var _PrescriptSetgridds = new Ext.data.Store({
	                proxy : new Ext.data.HttpProxy({
	                	url : "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProvPrescriptSet&pClassQuery=GetPrescriptSet" }),
	                reader : new Ext.data.JsonReader({
	                            totalProperty : 'total',
	                            root : 'data',
	                            successProperty : 'success'
	                        }, [{name : 'PSRowId', mapping : 'PSRowId', type : 'string' }, 
	                            {name : 'PSDesc',mapping : 'PSDesc',type : 'string'},
	                            {name : 'PSLinkFlag',mapping : 'PSLinkFlag',type : 'string' }
	                        ]) 
	     });
	     
	   var PrescriptSetgridsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : false, checkOnly : false, width : 20,
				listeners:{
					rowdeselect : function( e ,  rowIndex , record  ) 
					{ _PrescriptSetgridObj.getStore().getAt(rowIndex).set("PSLinkFlag","N") },    //当反选一个行时触发
					rowselect : function(  e ,  rowIndex , record ) 
					{ _PrescriptSetgridObj.getStore().getAt(rowIndex).set("PSLinkFlag","Y") }   //当选中一行数据时触发 
				}
		});
		
	    var _PrescriptSetgridObj = new Ext.grid.GridPanel({
	                region : 'center',
	                width : 210,
	                height : 180,
	                closable : true,
	                store : _PrescriptSetgridds,
	                trackMouseOver : true,
	                columnLines : true, //在列分隔处显示分隔符
	                sm:PrescriptSetgridsm,
	                columns : [PrescriptSetgridsm,
	                       	{header : '是否关联', width : 80,sortable : true, dataIndex : 'PSLinkFlag',hidden:true}, 
	                        {header : 'PSRowId',width : 80, sortable : true, dataIndex : 'PSRowId',hidden:true},
	                        {header : '处方权', width : 160, sortable : true, dataIndex : 'PSDesc'}],
	                stripeRows : true ,
	                stateful : true,
	                viewConfig : {
	                    forceFit : true
	                }
	            });			
		
	//全选框是否勾选 likefan 2020-11-25
	function hdcheckedfun(gridobj){
		//alert(gridobj.getSelectionModel().getSelections().length);	//所选中行的数量
		//alert(gridobj.getStore().getCount());	//所有行的数量
		var hd_checker = gridobj.getEl().select('div.x-grid3-hd-checker');
		var hd = hd_checker.first();
		if(hd != null){
			if (gridobj.getSelectionModel().getSelections().length!=gridobj.getStore().getCount())
			{
				hd.removeClass('x-grid3-hd-checker-on');	//清空表格头的checkBox
			}
			else
			{
				hd.addClass('x-grid3-hd-checker-on');	//选中表格头的checkBox
			}
		}
	}
		
    var WinForm = new Ext.form.FormPanel({              	//--------------弹出医护人员维护窗口表单部分
	    id:'form-save',
	    //layout : 'fit',
		//collapsible : true,
		title : '基本信息',
		//region: 'west',
		//bodyStyle : 'padding:5px 5px 0',
		//URL : SAVE_ACTION_URL_New,
		//baseCls : 'x-plain',//form透明,不显示框框
		labelAlign : 'right',
		labelWidth : 120,
		split : true,
		frame : true, //--------Panel具有全部阴影，若为false则只有边框有阴影			
		waitMsgTarget : true,
		reader: new Ext.data.JsonReader({root:'data'},
          [{ name: 'CTPCPRowId1', mapping:'CTPCPRowId1',type: 'string'},
			{ name: 'CTPCPCode', mapping:'CTPCPCode',type: 'string'},					
			{ name: 'CTPCPDesc', mapping:'CTPCPDesc',type: 'string'},
			{ name: 'CTPCPId', mapping:'CTPCPId',type: 'string'},
			{ name: 'CTPCPOtherName', mapping:'CTPCPOtherName',type: 'string'},
			{ name: 'CTPCPCarPrvTpDR', mapping:'CTPCPCarPrvTpDR',type: 'string'},
			{ name: 'CTPCPSpecDR', mapping:'CTPCPSpecDR',type: 'string'},
			{ name: 'CTPCPUnit', mapping:'CTPCPUnit',type: 'string'},
			{ name: 'CTPCPTextOne', mapping:'CTPCPTextOne',type: 'string'},
			{ name: 'CTPCPTextTwo', mapping:'CTPCPTextTwo',type: 'string'},
			{ name: 'CTSPCDesc', mapping:'CTSPCDesc',type: 'string'},
			{ name: 'CTPCPHICApproved', mapping:'CTPCPHICApproved',type: 'string'},
		    { name: 'CTPCPActiveFlag', mapping:'CTPCPActiveFlag',type: 'string'},
		    { name: 'CTPCPSpecialistYN',mapping:'CTPCPSpecialistYN', type: 'string' },
		    { name: 'CTPCPDateActiveFrom', mapping:'CTPCPDateActiveFrom',type: 'string'},
		    { name: 'CTPCPDateActiveTo',mapping:'CTPCPDateActiveTo', type: 'string'},
		    { name: 'CTPCPSurgeon', mapping:'CTPCPSurgeon', type: 'string' },
		    { name: 'CTPCPAnaesthetist',mapping:'CTPCPAnaesthetist', type: 'string'},//列的映射
		    /*{ name: 'CTPCPTelO',mapping:'CTPCPTelO',type:'string'},
			{ name: 'CTPCPTelH',mapping:'CTPCPTelH',type:'string'},
			{ name: 'CTPCPTelOExt',mapping:'CTPCPTelOExt',type:'string'},
			{ name: 'CTPCPMobilePhone',mapping:'CTPCPMobilePhone',type:'string'},
			{ name: 'CTPCPEmail',mapping:'CTPCPEmail',type:'string'},
			{ name: 'CTPCPFax',mapping:'CTPCPFax',type:'string'},*/
			{ name: 'CTPCPTitleDR',mapping:'CTPCPTitleDR',type:'string'},
			{ name: 'CTPCPMentalFlag',mapping:'CTPCPMentalFlag',type:'string'}
		]),
		defaults: {anchor:'95%'},
		items:
		{
			xtype:'fieldset',
			border:false,
			//title:'医护人员维护',
			autoHeight:true,
			items :[{
				baseCls : 'x-plain',
				layout:'column',
				border:false,
				items:[{
					baseCls : 'x-plain',
					columnWidth:'.5',
					layout: 'form',
					labelPad:1,//默认5
					border:false,
					defaults: {anchor:'90%'},
					items: [CTPCPCode,CTPCPDesc,CTPCPOtherName,CTPCPCarPrvTpDR,CTPCPTitleDR,CTPCPSpecDR,CTPCPUnit,CTPCPTextOne,CTPCPTextTwo,CTPCPId,CTPCPDateActiveFrom,CTPCPDateActiveTo,CTPCPActiveFlag,CTPCPSurgeon,CTPCPAnaesthetist,CTPCPSpecialistYN]					
				},{
					baseCls : 'x-plain',
				    columnWidth:'.5',
					layout: 'form',
					labelPad:1,
					border:false,
					defaults: {anchor:'90%'},
					items: [//CTPCPHICApprovedForm,CTPCPMentalFlag,
						
						{
							xtype : 'textfield',
							fieldLabel : 'CTPCPRowId1',
							hideLabel : 'True',
							hidden : true,
							id:'CTPCPRowId1',
							name : 'CTPCPRowId1'
						},{
							xtype : 'fieldset',
							title : '管制药品分类权限（可多选）',
							//width:200,
							autoHeight : true,
							style:'margin-left:90px', 
							items:[_PoisongridObj]
						},{
							xtype : 'fieldset',
							title : '关联处方权（可多选）',
							//width:200,
							autoHeight : true,
							style:'margin-left:90px', 
							items:[_PrescriptSetgridObj]
						}]						
				}]
			}/*,{
				xtype:'fieldset',
				title:'联系方式',
				items:[{
					baseCls : 'x-plain',
					layout : 'column',
					border : false,
					items:[{
						baseCls : 'x-plain',
						columnWidth : '.5',
						layout : 'form',
						labelWidth : 110,
						labelPad : 1,
						border : false,
						defaults : {
							anchor : '90%',
							xtype : 'textfield'
						},
						items:[CTPCPTelO,CTPCPTelOExt,CTPCPEmail]
					},{
						baseCls : 'x-plain',
						columnWidth : '.5',
						layout : 'form',
						labelPad : 1,
						border : false,
						defaults : {
							anchor : '90%',
							xtype : 'textfield'
						},
						items:[CTPCPTelH,CTPCPMobilePhone,CTPCPFax]
					}]
					}]
				}*/
				]
		}
	});
	
	/*****************************定义关联标签面板**2021-11-12**likefan*************************/
	
	var Label_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProvLinkLabel&pClassQuery=GetList";
	var Label_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCareProvLinkLabel&pClassMethod=SaveData";
	var Label_SAVEALL_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCareProvLinkLabel&pClassMethod=SaveAll";
	var Label_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCareProvLinkLabel&pClassMethod=DeleteData";
    var Label_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLabel&pClassQuery=GetDataForCmb1&table=CT_CareProv";
	
	//添加按钮
	var btnLabelAdd = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'btnLabelAdd',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnLabelAdd'),
				handler : AddLabelData=function() {
					if (Ext.getCmp("TextLabelDRF").getValue()=="") {
						Ext.Msg.show({ title : '提示', msg : '请选择要关联的标签!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
						return;
					}
					if (wincareprov.title=="修改"){
							var _record = grid.getSelectionModel().getSelected();
							Ext.Ajax.request({
								url : Label_SAVE_ACTION_URL,
								method : 'POST',
								params : {
									'doctorid':_record.get('CTPCPRowId1'),
									'labelid':Ext.getCmp("TextLabelDRF").getValue()
								},
								callback : function(options, success, response) {
									if (success) {
										var jsonData = Ext.util.JSON.decode(response.responseText);
										if (jsonData.success == 'true') {
											Ext.Msg.show({
												title : '<font color=blue>提示</font>',
												msg : '添加成功!',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													LabelRefresh();
												}
										   });
										} else {
											var errorMsg = '';
											if (jsonData.errorinfo) {
												errorMsg = '<br />错误信息:' + jsonData.errorinfo
											}
											Ext.Msg.show({
														title : '<font color=blue>提示</font>',
														msg : '<font color=red>添加失败!</font>' + errorMsg,
														minWidth : 200,
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
										}
									} else {
										Ext.Msg.show({
														title : '<font color=blue>提示</font>',
														msg : '<font color=red>异步通讯失败,请检查网络连接!</font>',
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
									}
								}
							}, this);
					}else{
						for (var i = 0; i < LabelGridds.getCount(); i++) {
							var record = LabelGridds.getAt(i);
							var CPLLLabelDR = record.get('CPLLLabelDR');
							if(Ext.getCmp('TextLabelDRF').getValue()==CPLLLabelDR){
								Ext.Msg.show({
									title:'提示',
									msg:'该记录已存在!',
									minWidth:200,
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
								return;
							}
						}
						var datarecord = new Ext.data.Record({
				    	 		'CPLLParRef':'',
				    	 		'CPLLRowId':'',
				    	 		'CPLLChildsub':'',
				    	 		'CPLLLabelDR':Ext.getCmp('TextLabelDRF').getValue(),
								'CPLLLabelDesc':Ext.getCmp('TextLabelDRF').getRawValue()
				    	 	});
				    	 	LabelGrid.stopEditing();
				    	 	LabelGridds.insert(0,datarecord); 	 
					}
				},
				scope : this
			});
	
	//删除按钮
	var btnLabelDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id:'btnLabelDel',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnLabelDel'),
		handler : DelLabelData=function() {
			var records =  LabelGrid.selModel.getSelections();
			var recordsLen= records.length;
			if(recordsLen == 0){
				Ext.Msg.show({
						title:'提示',
						minWidth:200,
						msg:'请选择需要删除的行!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
				});	
				return false;
			} 
			else{
				var gsm = LabelGrid.getSelectionModel();// 获取选择列
				var rows = gsm.getSelections();// 根据选择列获取到所有的行
				if (rows[0].get('CPLLRowId')!=""){	//修改医护人员时，有实际关联数据
					Ext.MessageBox.confirm('<font color=blue>提示</font>','<font color=red>确定要删除所选的数据吗?</font>', function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : Label_DELETE_ACTION_URL,
								method : 'POST',
								params : {
									'id':rows[0].get('CPLLRowId')
								},
								callback : function(options, success, response) {
									Ext.MessageBox.hide();
									if (success) {
										var jsonData = Ext.util.JSON.decode(response.responseText);
										if (jsonData.success == 'true') {
											Ext.Msg.show({
												title : '<font color=blue>提示</font>',
												msg : '<font color=red>删除成功!</font>',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													LabelRefresh();
												}
										   });
										} else {
											var errorMsg = '';
											if (jsonData.info) {
												errorMsg = '<br />错误信息:' + jsonData.info
											}
											Ext.Msg.show({
														title : '<font color=blue>提示</font>',
														msg : '<font color=red>数据删除失败!</font>' + errorMsg,
														minWidth : 200,
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
											}
								} else {
									Ext.Msg.show({
													title : '<font color=blue>提示</font>',
													msg : '<font color=red>异步通讯失败,请检查网络连接!</font>',
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
										}
								}
							}, this);
						}
					}, this);
				}else{	//新增医护人员时，无实际关联数据
					LabelGridds.remove(LabelGrid.getSelectionModel().getSelections());
				}
			} 
		}
	});
	
	//重置按钮
	var btnLabelRefresh = new Ext.Button({
				id : 'btnLabelRefresh',
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnLabelRefresh'),
				handler : LabelRefresh = function() {
					Ext.getCmp("TextLabelDRF").reset();
					if((wincareprov.title=="修改")&(grid.selModel.hasSelection())){
						var _record = grid.getSelectionModel().getSelected();
						LabelGridds.load({
							params:{parref:_record.get('CTPCPRowId1')}
						});
					}else{
						
					}
				}
	});
	
	//标签下拉框
	var TextLabelDR = new Ext.BDP.FunLib.Component.BaseComboBox({
		id : 'TextLabelDRF',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('TextLabelDRF'),
		//xtype : 'combo',
		width:200,
		// hiddenName:'TextLabelDR',//不能与id相同
		triggerAction : 'all',// query
		queryParam : "desc",
		forceSelection : true,
		selectOnFocus : false,
		mode : 'remote',
		//pageSize : Ext.BDP.FunLib.PageSize.Combo,
		//allQuery : '',
		//minChars : 1,
		listWidth : 250,
		valueField : 'ID',
		displayField : 'LabelName',
		store : new Ext.data.JsonStore({
					url : Label_QUERY_ACTION_URL,
					root : 'data',
					totalProperty : 'total',
					idProperty : 'ID',
					fields : ['ID', 'LabelName'],
					remoteSort : true,
					sortInfo : {
						field : 'ID',
						direction : 'ASC'
					}
				}),
		listeners:{
			'select': function(field,e){
				
			},
			'beforequery': function(e){
				this.store.baseParams = {
					desc:e.query
				};
				this.store.load({params : {
					
				}})

			}
		}
	});
	
	//工具条
	var tbLabel = new Ext.Toolbar({
				id : 'tbLabel',
				items : ['标签', TextLabelDR,'-', btnLabelAdd, '-', btnLabelDel, '-',btnLabelRefresh
				],
				listeners : {
					render : function() {
						//tbbutton.render(grid.tbar) 
					}
				}
			});
	
	//存储
	var LabelGridds = new Ext.data.Store({
	                proxy : new Ext.data.HttpProxy({
	                	url : Label_ACTION_URL }),
	                reader : new Ext.data.JsonReader({
	                            totalProperty : 'total',
	                            root : 'data',
	                            successProperty : 'success'
	                        }, [{name : 'CPLLParRef', mapping : 'CPLLParRef', type : 'string' }, 
	                            {name : 'CPLLRowId',mapping : 'CPLLRowId',type : 'string'},
	                            {name : 'CPLLChildsub',mapping : 'CPLLChildsub',type : 'string' },
	                            {name : 'CPLLLabelDR',mapping : 'CPLLLabelDR',type : 'string' },
	                            {name : 'CPLLLabelDesc',mapping : 'CPLLLabelDesc',type : 'string' }
	                        ]) 
	     });
	     
   var LabelGridsm = new Ext.grid.CheckboxSelectionModel({
			singleSelect : true, checkOnly : false, width : 20,
			listeners:{
				
			}
	});
	
	//面板
	var LabelGrid = new Ext.grid.GridPanel({
		region : 'center',
		id:'LabelGrid',
		title:'关联标签',
		//width : 210,
		//height : 230,
		//closable : true,
		store : LabelGridds,
		trackMouseOver : true,
		columnLines : true, //在列分隔处显示分隔符
		sm:LabelGridsm,
		columns : [LabelGridsm,
				{header : 'CPLLParRef', width : 160,sortable : true, dataIndex : 'CPLLParRef',hidden:true},
				{header : 'CPLLRowId',width : 160, sortable : true, dataIndex : 'CPLLRowId',hidden:true},
				{header : 'CPLLChildsub',width : 160, sortable : true, dataIndex : 'CPLLChildsub',hidden:true},
				{header : '标签DR', width : 160, sortable : true, dataIndex : 'CPLLLabelDR',hidden:true},
				{header : '标签', width : 160, sortable : true, dataIndex : 'CPLLLabelDesc'}],
		stripeRows : true ,
		stateful : true,
		tbar : tbLabel,
		viewConfig : {
			forceFit : true
		}
	});
	
	//添加医护人员时的保存方法
	function SaveLabel(doctorid) {
		var labelstr="";
	    LabelGridds.each(function(record){
			if(labelstr!="") labelstr = labelstr+"^";
			labelstr = labelstr+record.get('CPLLLabelDR');
	    }, this);
		Ext.Ajax.request({
			url:Label_SAVEALL_ACTION_URL,
			method:'POST',
			params:{
				'doctorid':doctorid,
				'labelidstr':labelstr
			}
		});  
	}
	
	/*****************************定义关联标签面板完*****************************/
	
	var tabs = new Ext.TabPanel({
			 activeTab : 0,
			 frame : true,
			 border : false,
			 animScroll:true,
			 enableTabScroll:true,
			 border:false,
			 defaults:{autoScroll:true},
			 items : [WinForm, LabelGrid, AliasGrid]
		 });
	
	var wincareprov = new Ext.Window({                 		//--------------弹出医护人员维护窗口部分
		title:'',
		width:800,
		height:Math.min(Ext.getBody().getViewSize().height-10,650),
		layout:'fit',
		plain:true,//true则主体背景透明
		modal:true,
		split : true,
		frame:true,
		buttonAlign:'center',
		closeAction:'hide',
		items: tabs,
		buttons:[{
			text:'保存',
			id:'save_btn',
			iconCls : 'icon-save',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler: function() {
				if(WinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}
				var startDate = Ext.getCmp("CTPCPDateActiveFrom").getValue();
			   	var endDate = Ext.getCmp("CTPCPDateActiveTo").getValue();
				if (startDate != "" && endDate != "") {
        			if (startDate > endDate) {
        				Ext.Msg.show({
        					title : '提示',
							msg : '开始日期不能大于结束日期！',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
          			 	return;
      				}
			   	}
				
				if(wincareprov.title=="添加"){
					WinForm.form.submit({
					clientValidation : true, // 进行客户端验证
					waitMsg : '正在提交数据请稍后',
					waitTitle : '提示',
					url : SAVE_ACTION_CareProv,
					method : 'POST',
					params : {									 
						'LinkHospId' :hospComp.getValue()         
					},
					success : function(form, action) {
						if (action.result.success == 'true') {
							wincareprov.hide();
							var myrowid = action.result.id;
							// var myrowid = jsonData.id;
							Ext.Msg.show({
								title : '提示',
								msg : '添加成功!',
								icon : Ext.Msg.INFO,
								buttons : Ext.Msg.OK,
								fn : function(btn) {
									var startIndex = grid.getBottomToolbar().cursor;
									grid.getStore().load({
										params : {
											start : 0,
											limit : pagesize,
											RowId1 : myrowid
										}
									});
								}
							});
							AliasGrid.DataRefer = myrowid;
							AliasGrid.saveAlias();
							
							//管制药品分类保存
							var linkstr="";
							_PoisongridObj.getStore().each(function(record){
								if(linkstr!="") linkstr = linkstr+"^";
								linkstr = linkstr+record.get('PHCPORowId')+'$'+record.get('LinkFlag');
							}, this);
							var resultPoison = tkMakeServerCall("web.DHCBL.CT.CTCareProvPHCPoison","UpdatePoison",action.result.id,linkstr);
							
							//关联处方权保存
							var linkstr2="";
							_PrescriptSetgridObj.getStore().each(function(record){
								if(linkstr2!="") linkstr2 = linkstr2+"^";
								linkstr2 = linkstr2+record.get('PSRowId')+'$'+record.get('PSLinkFlag');
							}, this);
							var resultPrescriptSet = tkMakeServerCall("web.DHCBL.CT.CTCareProvPrescriptSet","UpdatePrescriptSet",action.result.id,linkstr2);
							
							//关联标签保存
							SaveLabel(myrowid);
							
						} else {
							var errorMsg = '';
							if (action.result.errorinfo) {
								errorMsg = '<br/>错误信息:'+ action.result.errorinfo
							}
							Ext.Msg.show({
								title : '提示',
								msg : '添加失败!' + errorMsg,
								minWidth : 200,
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK
							});
						}
					},
					failure : function(form, action) {
						Ext.Msg.alert('提示', '添加失败.');
					}
				})
			} else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({
							clientValidation : true, // 进行客户端验证
							waitMsg : '正在提交数据请稍后',
							waitTitle : '提示',
							url : SAVE_ACTION_CareProv,
							method : 'POST',
							success : function(form, action) {
								AliasGrid.saveAlias();
								// alert(action);
								if (action.result.success == 'true') {
									wincareprov.hide();
									var myrowid = "RowId1="+ action.result.id;
									// var myrowid = jsonData.id;
									Ext.Msg.show({
										title : '提示',
										msg : '修改成功!',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK,
										fn : function(btn) {
											// salert(action.result);
											Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_CareProv,myrowid);
										}
									});
									
									//管制药品分类保存
									var linkstr="";
									_PoisongridObj.getStore().each(function(record){
										if(linkstr!="") linkstr = linkstr+"^";
										linkstr = linkstr+record.get('PHCPORowId')+'$'+record.get('LinkFlag');
									}, this);
									var resultPoison = tkMakeServerCall("web.DHCBL.CT.CTCareProvPHCPoison","UpdatePoison",action.result.id,linkstr);
									
									//关联处方权保存
									var linkstr2="";
									_PrescriptSetgridObj.getStore().each(function(record){
										if(linkstr2!="") linkstr2 = linkstr2+"^";
										linkstr2 = linkstr2+record.get('PSRowId')+'$'+record.get('PSLinkFlag');
									}, this);
									var resultPrescriptSet = tkMakeServerCall("web.DHCBL.CT.CTCareProvPrescriptSet","UpdatePrescriptSet",action.result.id,linkstr2);
									
								} 
								else {
									var errorMsg = '';
									if (action.result.errorinfo) {
										errorMsg = '<br/>错误信息:'+ action.result.errorinfo						
									}
									Ext.Msg.show({
										title : '提示',
										msg : '修改失败!' + errorMsg,
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
								}
							},
							failure : function(form, action) {
								Ext.Msg.alert('提示', '修改失败');
							}
						})
						}
					}, this);				
				}			
			}
			},{
			text:'关闭',
			iconCls : 'icon-close',
			handler:function(){
			wincareprov.hide();
			}
		}],
		listeners:{
			"show":function(){
				Ext.getCmp("CTPCPCode").focus(true,300);
			},
			"hide" : function() {
					Ext.BDP.FunLib.Component.FromHideClearFlag(); //form隐藏时，清空之前判断重复验证的对勾、
				},
			"close":function(){
			}
		}
	});
    
	
	
	var btnChart = new Ext.Toolbar.Button({				//人员类型详细图
	    text: '人员分布图表',
        iconCls: 'icon-Chart',
		tooltip: '人员分布图表',
		id:'btnChart',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnChart'),
        handler: function Chart() {     
			ChartWin.setTitle('人员分布图表');
			ChartWin.setIconClass('icon-Chart');
			ChartWin.show('');
        }
	});
	
    var ChartWin = new Ext.Window(getChartWin());  //调用CT_CareProv_Charts.js的指定科室面板
	
	var btnDesignatedDepartment = new Ext.Toolbar.Button({    //指定科室
	    text: '指定科室',
        tooltip: '指定科室',
        icon: Ext.BDP.FunLib.Path.URL_BdpIcon+'CT_Loc.png',
        id:'btnDesignatedDepartment',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnDesignatedDepartment'),
        handler: function DesignatedDepartment() {
        if(grid.selModel.hasSelection()){      
        	 	var gsm = grid.getSelectionModel();//获取选择列
                var rows = gsm.getSelections();//根据选择列获取到所有的行
                
                var id = rows[0].get('CTPCPRowId1');
                var className =  "web.DHCBL.CT.CTCarPrvTp";		//后台类名称
			    var classMethod = "GetInternalTypeForCareID";				//数据重复验证后台函数名	                            
			    var flag = "";
		        var flag = tkMakeServerCall(className,classMethod,id);	//用tkMakeServerCall函数实现与后台同步调用交互
		        RBCTLOCStore.baseParams={type:flag}
	            RBCTLOCStore.load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Combo}});
	               
		        //alert(flag);
		        //var BindingLoc="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1&type="+flag;
				//var BindingLoc1="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1&type="+flag;
		        
				winDesignatedDepartment.setTitle('指定科室');
			    winDesignatedDepartment.setIconClass('icon-DP');
			    winDesignatedDepartment.show('');
			   
                var RESCode=rows[0].get('CTPCPCode');
                gridResource.getStore().baseParams={Code:RESCode};
                gridResource.getStore().load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});
                var RESCTPCPDR=rows[0].get('CTPCPRowId1');
                var RESDesc=rows[0].get('CTPCPDesc');
                
                Ext.getCmp("hidden_RESCode").reset();
                Ext.getCmp("hidden_RESCode").setValue(RESCode);
                Ext.getCmp("hidden_RESCTPCPDR").reset();
                Ext.getCmp("hidden_RESCTPCPDR").setValue(RESCTPCPDR);
                Ext.getCmp("hidden_RESDesc").reset();
                Ext.getCmp("hidden_RESDesc").setValue(RESDesc);
                Ext.getCmp("comboxResource").reset();
                Ext.getCmp("hidden_RESHOSPDR").reset();
                Ext.getCmp("hidden_RESHOSPDR").setValue(hospComp.getValue());
               
		       	//CTLOCStore.baseParams={type:flag}
				//getForm().getValues() getForm().getFieldValues()
		}
        else
		{
			Ext.Msg.show({
						title:'提示',
						msg:'请选择需要指定科室的医护人员!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
			}

        }
	});

    var winDesignatedDepartment = new Ext.Window(getResourcePanel());  //调用CT_CareProv_Resource.js的指定科室面板
    
	var sm = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
	
	var fields=  [{ name: 'CTPCPRowId1', mapping:'CTPCPRowId1',type: 'string'},
			{ name: 'CTPCPCode', mapping:'CTPCPCode',type: 'string'},					
			{ name: 'CTPCPDesc', mapping:'CTPCPDesc',type: 'string'},
			{ name: 'CTPCPId', mapping:'CTPCPId',type: 'string'},
			{ name: 'CTPCPOtherName', mapping:'CTPCPOtherName',type: 'string'},
			{ name: 'CTPCPCarPrvTpDR', mapping:'CTPCPCarPrvTpDR',type: 'string'},
			{ name: 'CTPCPSpecDR', mapping:'CTPCPSpecDR',type: 'string'},
			{ name: 'CTPCPUnit', mapping:'CTPCPUnit',type: 'string'},
			{ name: 'CTPCPTextTwo', mapping:'CTPCPTextTwo',type: 'string'},
			{ name: 'CTPCPSpecDR', mapping:'CTPCPSpecDR',type: 'string'},
		    { name: 'CTPCPActiveFlag', mapping:'CTPCPActiveFlag',type: 'string'},
		    { name: 'CTPCPSpecialistYN',mapping:'CTPCPSpecialistYN', type: 'string' },
		    { name: 'CTPCPDateActiveFrom', mapping:'CTPCPDateActiveFrom',type: 'string'},
		    { name: 'CTPCPDateActiveTo',mapping:'CTPCPDateActiveTo', type: 'string'},
		    { name: 'CTPCPSurgeon', mapping:'CTPCPSurgeon', type: 'string' },
		    { name: 'CTPCPHICApproved',mapping:'CTPCPHICApproved', type: 'string'},
		    { name: 'CTPCPAnaesthetist',mapping:'CTPCPAnaesthetist', type: 'string'},
		    { name: 'CTPCPMentalFlag',mapping:'CTPCPMentalFlag', type: 'string'},
			{ name: 'CTPCPUpdateDate', mapping:'CTPCPUpdateDate', type: 'string'},
		    { name: 'CTPCPUpdateUserDR', mapping:'CTPCPUpdateUserDR', type: 'string' }
			];
	var dscareprov = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_CareProv}),//调用的动作
        reader: new Ext.data.JsonReader({
            	totalProperty: 'total',
            	root: 'data',
            	successProperty :'success'
        	},fields
		  ),
		remoteSort: true
    });
    
    Ext.BDP.AddReaderFieldFun(dscareprov,fields,Ext.BDP.FunLib.TableName);
    /*
	if(InternalType!="demo")
    {	    
    dscareprov.load({
			params:{start:0, limit:pagesize,InternalType:InternalType},
			callback: function(records, options, success){
			}
		});
    }
    else
    {
    	  dscareprov.load({
			params:{start:0, limit:pagesize},
			callback: function(records, options, success){
			}
		});
    }
	*/
	var pagingcareprov= new Ext.PagingToolbar({
            pageSize: pagesize,
            store: dscareprov,
            displayInfo: true,
			//plugins: new Ext.ux.ProgressBarPager()
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
			//plugins: new Ext.ux.ProgressBarPager()，
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
			listeners : {
			          "change":function (t,p)
			         { 
			             pagesize=this.pageSize;
			         }
	        }
        })
/*     var btnHospital = new Ext.Toolbar.Button({
        text: '医院关联',
        tooltip: '医院关联',
        iconCls: 'icon-DP',
        id:'btnHospital',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnHospital'),
      	handler: function Hosp() {			        
			var records =  grid.selModel.getSelections();
			var recordsLen= records.length;
			if(recordsLen == 0){
					Ext.Msg.show({
									title:'提示',
									minWidth:200,
									msg:'请选择一行进行维护!',
									icon:Ext.Msg.WARNING,
									buttons:Ext.Msg.OK
								});	
							 return
						 };
			if(recordsLen > 1){
					Ext.Msg.show({
									title:'提示',
									minWidth:200,
									msg:'请选择其中一行进行维护!',
									icon:Ext.Msg.WARNING,
									buttons:Ext.Msg.OK
								});
			  }
			 else{
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
				    var itemdesc=rows[0].get('CTPCPDesc');
				    var itemRowId=rows[0].get('CTPCPRowId1')
                	var link="dhc.bdp.ext.default.csp?extfilename=App/Care/CT_CareProv_Hospital&selectrow="+itemRowId; 
                	var winHospital = new Ext.Window({
									iconCls : 'icon-DP',
									width : 700,
									height : 450,
									layout : 'fit',
									plain : true,// true则主体背景透明
									modal : true,
									frame : true,
									autoScroll : false,
									collapsible : true,
									hideCollapseTool : true,
									titleCollapse : true,
									constrain : true,
									closeAction : 'close',
									html : ''
									listeners : {
										"show" : function(){
											if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
										    {
										    	keymap_main.disable();
										    }
										},
										"hide" : function(){
										},
										"close" : function(){
											if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
										    {
												keymap_main.enable();
										    }
										}
									}
								});
					winHospital.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';
					winHospital.setTitle(itemdesc+"-医院关联");
					winHospital.show();
			 }
      	}
    });*/
    var winHospital = new Ext.Window(getCTCareProvHospPanel());  //调用CT_CareProv_Hospital.js的医院关联面板
	
	var btnHospital = new Ext.Toolbar.Button({				//关联医院
	    text: '医院关联',
	    id:'btnHospital',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnHospital'),
        icon: Ext.BDP.FunLib.Path.URL_BdpIcon+'CT_Hospital.png',
		tooltip: '医院关联',
        handler: Hosp = function() {   
    	var _record = grid.getSelectionModel().getSelected();
        if(_record){
			winHospital.setTitle('医院关联');
			winHospital.setIconClass('icon-DP');
			winHospital.show('');
			var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行 
            var CTPCPRowId=rows[0].get('CTPCPRowId1');
            Ext.getCmp("HOSPParRef").reset();
           	Ext.getCmp("HOSPParRef").setValue(CTPCPRowId);
            gridCTCareProvHosp.getStore().baseParams={ParRef:CTPCPRowId};
           	gridCTCareProvHosp.getStore().load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});
           	Ext.getCmp("txtHospital").getStore().load();
        }
	        else
			{
				Ext.Msg.show({
						title:'提示',
						msg:'请选择一行进行维护!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
			}		
        }
	});
	
	var winMed = new Ext.Window(getMedUnitPanel());  //调用CT_CareProv_MedUnit.js的医疗单元面板
	
	var btnMedUnit = new Ext.Toolbar.Button({				//关联医院
	    text: '所属医疗单元',
	    id:'btnMedUnit',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnMedUnit'),
        icon: Ext.BDP.FunLib.Path.URL_BdpIcon+'DHC_CTLoc_MedUnit.png',
		tooltip: '所属医疗单元',
        handler: Med = function() {   
    	var _record = grid.getSelectionModel().getSelected();
        if(_record){
			winMed.setTitle('所属医疗单元');
			winMed.setIconClass('icon-DP');
			winMed.show('');
			var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行 
            var CTPCPRowId=rows[0].get('CTPCPRowId1');
            var CTPCPCode=rows[0].get('CTPCPCode');
            var CTPCPDesc=rows[0].get('CTPCPDesc');
            Ext.getCmp("DoctorDRF").reset();
            Ext.getCmp("CTPCPCodeF").reset();
            Ext.getCmp("CTPCPDescF").reset();
            Ext.getCmp("DoctorDRF").setValue(CTPCPRowId);
           	Ext.getCmp("CTPCPCodeF").setValue(CTPCPCode);
           	Ext.getCmp("CTPCPDescF").setValue(CTPCPDesc);
			Ext.getCmp("HospDR").setValue(hospComp.getValue());
            gridMedUnit.getStore().baseParams={DoctorDR:CTPCPRowId};
           	gridMedUnit.getStore().load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});
           	//Ext.getCmp("txtHospital").getStore().load();
        }
	        else
			{
				Ext.Msg.show({
						title:'提示',
						msg:'请选择一行进行维护!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
			}		
        }
	});
	// 删除功能
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function() {   
			if (grid.selModel.hasSelection()) {
				//Ext.MessageBox.confirm(String title,String msg,[function fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();
						var rows = gsm.getSelections();
						
						//删除所有别名
						AliasGrid.DataRefer = rows[0].get('CTPCPRowId1');
						AliasGrid.delallAlias();
									
						//Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('CTPCPRowId1')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true')
									{
										//var myrowid = action.result.id;                
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
											}
									});
								}
								else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								} 
								else {
									Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接！',
												icon : Ext.Msg.ERROR,
												buttons : Ext.Msg.OK
											});
								}
							}
						}, this);
					}
				}, this);
			} else {
				Ext.Msg.show({
							title : '提示',
							msg : '请选择需要删除的行！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});
    var btnDelcareprov = new Ext.Toolbar.Button({       //------------------------停用按钮
        text: '停用',
        tooltip: '停用',       
        iconCls: 'icon-stop',
        id:'btnDelcareprov',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnDelcareprov'),
        handler: function StopData() {
			if(grid.selModel.hasSelection()){
				var gsm = grid.getSelectionModel();//获取选择列
                var rows = gsm.getSelections();//根据选择列获取到所有的行
                if(rows[0].get('CTPCPActiveFlag')=="N")
                {
                	Ext.Msg.show({
						title:'提示',
						msg:'您所选的医护人员已经被停用！',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
                }
                else
                {                	               
					Ext.MessageBox.confirm('提示','确定要停用该医护人员吗?',function(btn){
						if(btn=='yes'){
							Ext.Ajax.request({
								url:STOP_ACTION_CareProv,
								method:'POST',
								params:{
									'id':rows[0].get('CTPCPRowId1')
								},
								callback:function(options, success, response){
									if(success){
										var jsonData = Ext.util.JSON.decode(response.responseText);
										var myrowid = "RowId1="+ rows[0].get('CTPCPRowId1');
										if(jsonData.success == 'true'){
											Ext.Msg.show({
												title:'提示',
												msg:'停用成功!',
												icon:Ext.Msg.INFO,
												buttons:Ext.Msg.OK,
												fn:function(btn){
													Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_CareProv,myrowid);
												}
											});
										}
										else{
											var errorMsg ='';
											if(jsonData.errorinfo){
												errorMsg='<br />错误信息:'+jsonData.errorinfo
											}
											Ext.Msg.show({
												title:'提示',
												msg:'停用失败!'+errorMsg,
												minWidth:200,
												icon:Ext.Msg.ERROR,
												buttons:Ext.Msg.OK
											});
										}
									}
									else{
										Ext.Msg.show({
											title:'提示',
											msg:'异步通讯失败,请检查网络连接!',
											icon:Ext.Msg.ERROR,
											buttons:Ext.Msg.OK
										});
									}
								}
							},this);
						}
					},this);
                }
		}
		else{
			Ext.Msg.show({
				title:'提示',
				msg:'请选择需要停用的医护人员!',
				icon:Ext.Msg.WARNING,
				buttons:Ext.Msg.OK
			});
		}
        }
    });
	var btnAddwincareprov = new Ext.Toolbar.Button({    //------------------------增加按钮
        text: '添加',
        tooltip: '添加',
        iconCls: 'icon-add',
        id:'add_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
        handler: AddData=function() {
			wincareprov.setTitle('添加');
			wincareprov.setIconClass('icon-add');
			wincareprov.show('');
			WinForm.getForm().reset();
			if (!Ext.getCmp("CTPCPHICApproved").getValue())
			{
				Ext.getCmp("CTPCPHICApprovedButton").setDisabled(true);
			}
			else
			{
				Ext.getCmp("CTPCPHICApprovedButton").setDisabled(false);
			}
			 //激活基本信息面板
            tabs.setActiveTab(0);
	        //清空别名面板grid
            AliasGrid.DataRefer = "";
            AliasGrid.clearGrid();
			
			//管制药品分类面板
			_Poisongridds.load({
				params:{parref:0},
				callback: function(records, options, success){
					var records=[];//存放选中记录  
					for(var i=0;i<_Poisongridds.getCount();i++){  
						var record = _Poisongridds.getAt(i);  
						if(record.data.LinkFlag=='Y'){ records.push(record);   }  
					}  
					gridsm.selectRecords(records);//执行选中已对照的记录  
					hdcheckedfun(_PoisongridObj)	//全选框是否勾选 2020-11-25
				}
			});
			//关联处方权面板
			_PrescriptSetgridds.load({
				params:{
					parref:0,
					hospid:hospComp.getValue()
				},
				callback: function(records, options, success){
					var records=[];//存放选中记录  
					for(var i=0;i<_PrescriptSetgridds.getCount();i++){  
						var record = _PrescriptSetgridds.getAt(i);  
						if(record.data.PSLinkFlag=='Y'){ records.push(record);   }  
					}  
					PrescriptSetgridsm.selectRecords(records);//执行选中已对照的记录  
					hdcheckedfun(_PrescriptSetgridObj);	//全选框是否勾选 2020-11-25
				}
			});
			
			//关联标签
			Ext.getCmp("TextLabelDRF").reset();
			LabelGridds.load({
				params:{}
			});
			
    },
        scope: this
    });
    var btnEditwincareprov = new Ext.Toolbar.Button({   //------------------------修改按钮
        text: '修改',
        tooltip: '修改',
        iconCls: 'icon-update',
        id:'update_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
        handler:  UpdateData=function() {
        if(grid.selModel.hasSelection()){
        	wincareprov.setTitle('修改');
		    wincareprov.setIconClass('icon-update');
		    wincareprov.show('');
			if (!Ext.getCmp("CTPCPHICApproved").getValue())
			{
				Ext.getCmp("CTPCPHICApprovedButton").setDisabled(true);
			}
			else
			{
				Ext.getCmp("CTPCPHICApprovedButton").setDisabled(false);
			}
			var _record = grid.getSelectionModel().getSelected();//records[0]			
			Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&RowId1=' + _record.get('CTPCPRowId1'),
		                waitMsg : '正在载入数据...',
		                success : function(form,action) {
		                    //Ext.Msg.alert(action);
		                	//Ext.example.msg('编辑', '载入成功ㄐ');
		                	//Ext.Msg.alert('编辑', '载入成功');
		                },
		                failure : function(form,action) {
		                    //Ext.example.msg('编辑', '载入失败');
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
				/*
		        var gsm = grid.getSelectionModel();//获取选择列
                Ext.getCmp("CTPCPActiveFlag").setValue(CTPCPActiveFlag);*/
            //激活基本信息面板
            tabs.setActiveTab(0);
	        //加载别名面板
            AliasGrid.DataRefer = _record.get('CTPCPRowId1');
    	    AliasGrid.loadGrid();   
		            
			//管制药品分类面板
			_Poisongridds.load({
				params:{parref:_record.get('CTPCPRowId1')},
				callback: function(records, options, success){
					var records=[];//存放选中记录  
					for(var i=0;i<_Poisongridds.getCount();i++){  
						var record = _Poisongridds.getAt(i);  
						if(record.data.LinkFlag=='Y'){ records.push(record);   }  
					}  
					gridsm.selectRecords(records);//执行选中已对照的记录  
					hdcheckedfun(_PoisongridObj);	//全选框是否勾选 2020-11-25
				}
			});
			//关联处方权面板
			_PrescriptSetgridds.load({
				params:{
					parref:_record.get('CTPCPRowId1'),
					hospid:hospComp.getValue()
				},
				callback: function(records, options, success){
					var records=[];//存放选中记录  
					for(var i=0;i<_PrescriptSetgridds.getCount();i++){  
						var record = _PrescriptSetgridds.getAt(i);  
						if(record.data.PSLinkFlag=='Y'){ records.push(record);   }  
					}  
					PrescriptSetgridsm.selectRecords(records);//执行选中已对照的记录  
					hdcheckedfun(_PrescriptSetgridObj);	//全选框是否勾选 2020-11-25
				}
			});
			
			//关联标签
			Ext.getCmp("TextLabelDRF").reset();
			LabelGridds.load({
				params:{parref:_record.get('CTPCPRowId1')}
			});
			
		}
        else
		{
		Ext.Msg.show({
					title:'提示',
					msg:'请选择需要修改的行!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
		}

        }
    });
	
    var tbbutton=new Ext.Toolbar({
		enableOverflow: true,
		items:[btnAddwincareprov, '-', btnEditwincareprov, '-',btnDel,'-', btnDelcareprov,'-',btnDesignatedDepartment,'-',btnHospital, '-', btnMedUnit,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog ]
	});
	var btnSearch=new Ext.Button({
        id:'btnSearch',
        iconCls:'icon-search',
        text:'搜索',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
        handler:function(){
        	if(InternalType=="Nothing")
        	{
        		alert("你没有权限进行检索");
        	}
        	else
        	{
		    	if(InternalType!="demo")
			    {	    
			    	grid.getStore().baseParams={
			    		InternalType:InternalType,
						Code:Ext.getCmp("CareID").getValue(),
						Desc:Ext.getCmp("CareName").getValue(),
						CarPrvTpDR:Ext.getCmp("CarePrvTp").getValue(),
						ActiveFlag:Ext.getCmp("ActiveFlag").getValue(),
						HICApprovedFlag : Ext.getCmp("CTPCPHICApprovedFlag").getValue(),
						Hospital:hospComp.getValue()
					};
			    }
			    else
			    {
			    	grid.getStore().baseParams={			
				      	Code:Ext.getCmp("CareID").getValue(),
					 	Desc:Ext.getCmp("CareName").getValue(),
					 	CarPrvTpDR:Ext.getCmp("CarePrvTp").getValue(),
					 	ActiveFlag:Ext.getCmp("ActiveFlag").getValue(),
					 	HICApprovedFlag : Ext.getCmp("CTPCPHICApprovedFlag").getValue(),
					 	Hospital:hospComp.getValue()
					};
			    }
		        grid.getStore().load({params:{start:0, limit:pagesize}});
        	}
        }

    });
		
	//刷新工作条
	var btnRefresh = new Ext.Button({
        id:'btnRefresh',
        iconCls:'icon-refresh',
        text:'重置',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
        handler:function Refresh(){
        	
        	Ext.BDP.FunLib.SelectRowId =""; //翻译
        	
			Ext.getCmp("CareID").reset();
			Ext.getCmp("CareName").reset();
			Ext.getCmp("CarePrvTp").reset();
			Ext.getCmp("ActiveFlag").reset();
			Ext.getCmp("CTPCPHICApprovedFlag").reset();
			//Ext.getCmp("hospital").reset();
			grid.getStore().baseParams={
				Hospital:hospComp.getValue()
			};
				/*if(InternalType!="demo")
			{
				grid.getStore().baseParams={			
			   	InternalType:InternalType
			};
		}*/
			grid.getStore().load({params:{start:0, limit:pagesize}});
		//}
        }

    });
				
    var careprovtype = new Ext.BDP.Component.form.ComboBox({
    	width:100,
    	loadByIdParam : 'rowid',
		fieldLabel: '医护人员类型',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('CarePrvTp'),
		id:'CarePrvTp',
		//triggerAction:'all',//query
		forceSelection: true,
		selectOnFocus:false,
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		listWidth:250,
		valueField:'CTCPTRowId',
		displayField:'CTCPTDesc',
		store:new Ext.data.JsonStore({
			url:BindingCarPrvTp,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'CTCPTRowId',
			fields:['CTCPTRowId','CTCPTDesc']
		}),
		listeners:{
			//传值之前时就把查询条件赋值给它
	        'loadbefore': function(field, e){
	        	careprovtype.getStore().baseParams={
	        		InternalType : "DOCTOR"
        		};
	        }
		}
	});
        
	var ActiveFlag= new Ext.form.ComboBox({
		fieldLabel: '状态',
		xtype:'combo',
		id:'ActiveFlag',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('ActiveFlag'),
		width:100,
		mode:'local',
		hiddenName:'hxxx',//不能与id相同
		triggerAction:'all',//query
		forceSelection: true,
		selectOnFocus:false,
		listWidth:100,
		valueField:'value',
		displayField:'name',
		store: new Ext.data.JsonStore({
	        fields : ['name', 'value'],
	        data   : [
	            {name : '已激活',   value: 'Y'},
	            {name : '未激活',  value: 'N'}
	        ]
	    })

	});
	
	var CTPCPHICApprovedFlag= new Ext.form.ComboBox({
		fieldLabel: '毒麻处方权',
		xtype:'combo',
		id:'CTPCPHICApprovedFlag',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPHICApprovedFlag'),
		width:100,
		mode:'local',
		hiddenName:'hxxx',//不能与id相同
		triggerAction:'all',//query
		forceSelection: true,
		selectOnFocus:false,
		listWidth:100,
		valueField:'value',
		displayField:'name',
		store: new Ext.data.JsonStore({
	        fields : ['name', 'value'],
	        data   : [
	            {name : 'Yes',   value: 'Y'},
	            {name : 'No',  value: 'N'}
	        ]
	    })
	});
	
	//工具栏
    var tb= new Ext.Toolbar({
        id:'tb',
        items:[
            '代码',
            {
				xtype: 'textfield',
				width: 100,
				id: 'CareID',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CareID')
			},
            '-',
            '姓名',
            {
				xtype: 'textfield',
				width: 100,
				id: 'CareName',
				emptyText : '描述/别名',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CareName')
			},
            '-',
            '医护人员类型',
            careprovtype,
            '-',
            '状态',
            ActiveFlag,
            //'-',
            //'毒麻处方权',
            //CTPCPHICApprovedFlag,
            //'-',
            //'医院',
            //hospital,
            '-',
            Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),
            '-',
            btnSearch,
			'-',
			btnRefresh,
            '->',
            helphtmlbtn
        ],
		listeners:{
        render:function(){
        tbbutton.render(grid.tbar)  //tbar.render(panel.bbar)这个效果在底部
        }
    }
	});
	var GridCM =[
		    sm,
		    { header: 'CTPCPRowId1', sortable: true, dataIndex: 'CTPCPRowId1',hidden:true },
		    { header: '代码',sortable: true, dataIndex: 'CTPCPCode',width : 60},
		    { header: '姓名',sortable: true, dataIndex: 'CTPCPDesc',width : 80 },
		    { header: '标识码',sortable: true, dataIndex: 'CTPCPId',width : 80  },
		    { header: '拼音检索码',sortable: true, dataIndex: 'CTPCPOtherName',width : 80  },
		    { header: '医护人员类型',sortable: true, dataIndex: 'CTPCPCarPrvTpDR',width : 100 },
		    { header: '专长',sortable: false,dataIndex: 'CTPCPSpecDR',width : 80  },
		    { header: '专业资格证书号',sortable: false,dataIndex: 'CTPCPUnit',width : 140 },
		    { header: '激活',sortable: true, dataIndex: 'CTPCPActiveFlag',width : 60,renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon},
		    { header: '可以出特需号',sortable: true, dataIndex: 'CTPCPSpecialistYN',width : 80,renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon},
		    { header: '外科医生',sortable: true, dataIndex: 'CTPCPSurgeon',width : 60,renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon},
		    { header: '麻醉师',sortable: true, dataIndex: 'CTPCPAnaesthetist',width : 60,renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon},
		    //{ header: '毒麻处方权',sortable: true, dataIndex: 'CTPCPHICApproved',width : 60,renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon},
		    //{ header: '精神类药物处方权',sortable: true, dataIndex: 'CTPCPMentalFlag',width : 90,renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon},	    
		    { header: '开始日期',sortable: true, dataIndex: 'CTPCPDateActiveFrom' },
		    { header: '结束日期',sortable: true, dataIndex: 'CTPCPDateActiveTo' },
		    { header: '修改日期',sortable: true, dataIndex: 'CTPCPUpdateDate', hidden : true  },
		    { header: '修改人',sortable: true, dataIndex: 'CTPCPUpdateUserDR', hidden : true }
		];
	var grid = new Ext.grid.GridPanel({
		id:'grid',
		region: 'center',
		closable:true,
		store: dscareprov,
		align:'center',
		trackMouseOver: true,
		//clicksToEdit: 1,
		columns: GridCM,
	    stripeRows: true,
	   // loadMask: { msg: '数据加载中,请稍候...' },
	    title: '医护人员维护',
	    stateful: true,
	    tools:Ext.BDP.FunLib.Component.HelpMsg,
	    viewConfig: {forceFit: true},
		bbar:pagingcareprov,
		tbar:tb,
	    stateId: 'grid'
	});
	
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
  	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
  	
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	
	grid.on("rowdblclick",function(grid,rowIndex,e){
		wincareprov.setTitle('修改');
	    wincareprov.setIconClass('icon-update');
	    wincareprov.show('');
	    if (!Ext.getCmp("CTPCPHICApproved").getValue())
		{
			Ext.getCmp("CTPCPHICApprovedButton").setDisabled(true);
		}
		else
		{
			Ext.getCmp("CTPCPHICApprovedButton").setDisabled(false);
		}
		    
			 
			var _record = grid.getSelectionModel().getSelected();//records[0]
			
			Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&RowId1=' + _record.get('CTPCPRowId1'),
		                waitMsg : '正在载入数据...',
		                success : function(form,action) {
		                },
		                failure : function(form,action) {
		                    //Ext.example.msg('编辑', '载入失败');
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		
		  	//激活基本信息面板
            tabs.setActiveTab(0);
	        //加载别名面板
            AliasGrid.DataRefer = _record.get('CTPCPRowId1');
	        AliasGrid.loadGrid();
			
			//管制药品分类面板
			_Poisongridds.load({
				params:{parref:_record.get('CTPCPRowId1')},
				callback: function(records, options, success){
					var records=[];//存放选中记录  
					for(var i=0;i<_Poisongridds.getCount();i++){  
						var record = _Poisongridds.getAt(i);  
						if(record.data.LinkFlag=='Y'){ records.push(record);   }  
					}  
					gridsm.selectRecords(records);//执行选中已对照的记录
					hdcheckedfun(_PoisongridObj);	//全选框是否勾选 2020-11-25
				}
			});
			//关联处方权面板
			_PrescriptSetgridds.load({
				params:{
					parref:_record.get('CTPCPRowId1'),
					hospid:hospComp.getValue()
				},
				callback: function(records, options, success){
					var records=[];//存放选中记录  
					for(var i=0;i<_PrescriptSetgridds.getCount();i++){  
						var record = _PrescriptSetgridds.getAt(i);  
						if(record.data.PSLinkFlag=='Y'){ records.push(record);   }  
					}  
					PrescriptSetgridsm.selectRecords(records);//执行选中已对照的记录  
					hdcheckedfun(_PrescriptSetgridObj);	//全选框是否勾选 2020-11-25
				}
			});
			
			//关联标签
			Ext.getCmp("TextLabelDRF").reset();
			LabelGridds.load({
				params:{parref:_record.get('CTPCPRowId1')}
			});
			        
	});		

		//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('CTPCPRowId1');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
	
    /**---------------------右键菜单-------------------**/
  
   
    
	   if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器
  	  {
            grid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分
			var rightClick = new Ext.menu.Menu({
    		id:'rightClickCont', //在HTML文件中必须有个rightClickCont的DIV元素
    		disabled : Ext.BDP.FunLib.Component.DisableFlag('rightClickCont'),
    		items: [
    		{
	            iconCls :'icon-add',
	            handler: AddData,
	            id:'menu1',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menu1'),
	            text: '添加'
	        },{
	            iconCls :'icon-Update',
	            handler: UpdateData,
	             id:'menu2',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menu2'),
	            text: '修改'
	        },{
	            iconCls :'icon-delete',
	            handler: DelData,
	             id:'menu3',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menu3'),
	            text: '删除'
	        },{
	            iconCls :'icon-stop',
	            handler: StopData,
	             id:'menu4',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menu4'),
	            text: '停用'
	        },{
	            icon: Ext.BDP.FunLib.Path.URL_BdpIcon+'CT_Loc.png',
	            handler: DesignatedDepartment,
	             id:'menu5',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menu5'),
	            text: '指定科室'
	        }/*,{
	            iconCls :'icon-useredit',
	            handler: SpecEdit,
	             id:'menu6',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menu6'),
	            text: '医生专长维护'
	        },{
	            iconCls :'icon-useredit',
	            handler: CarPrvTpEdit,
	             id:'menu7',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menu7'),
	            text: '医护人员类型维护'
	        }*/,{
	            iconCls :'icon-Chart',
	            handler: Chart,
	             id:'menu8',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menu8'),
	            text: '人员分布图表'
	        },{
	            icon: Ext.BDP.FunLib.Path.URL_BdpIcon+'CT_Hospital.png',
	            handler: Hosp,
	             id:'menu9',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menu9'),
	            text: '医院关联'
	        },{
	            icon: Ext.BDP.FunLib.Path.URL_BdpIcon+'DHC_CTLoc_MedUnit.png',
	            handler: Med,
	             id:'menu10',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menu10'),
	            text: '所属医疗单元'
	        },{
	            iconCls :'icon-refresh',
	            handler: Refresh,
	             id:'menu10',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menu11'),
	            text: '刷新'
	        }]     	
}); 
 	function rightClickFn(grid,rowindex,e){
    	 e.preventDefault();
    	 var currRecord = false; 
   		 var currRowindex = false; 
   		 var currGrid = false; 
         if (rowindex < 0) { 
         return; 
   } 
     grid.getSelectionModel().selectRow(rowindex); 
     currRowIndex = rowindex; 
     currRecord = grid.getStore().getAt(rowindex); 
     currGrid = grid; 
     rightClick.showAt(e.getXY()); 
  }
}	

/************************************ 调用keymap*********************************************/
	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	
	/**---------------------右键菜单-------------------**/	
    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [{
					frame:true,
					xtype: 'panel',
			        region: 'north',
			        layout:'form',
			        labelAlign : 'right',
					labelWidth : 30,
					items:[hospComp],
			        height: 35,
			        border: false
			    },grid]
    });
});
