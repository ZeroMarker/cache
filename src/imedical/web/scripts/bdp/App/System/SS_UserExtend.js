	
	/// 名称：用户扩展信息维护
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 陈莹
	/// 编写日期:2019-04-08
	//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
Ext.onReady(function() {
	
	
	var SSUSRRowId=Ext.BDP.FunLib.getParam('selectrow')
	var SSUSRE_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUserExtend&pClassMethod=OpenData";
	var SSUSRE_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SSUserExtend&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.SSUserExtend"; 
	var CTNation_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTNation&pClassQuery=GetDataForCmb1";
	var CTCountry_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCountry&pClassQuery=GetDataForCmb1";
	var CTMarital_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTMarital&pClassQuery=GetDataForCmb1";
	var CTEducation_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTEducation&pClassQuery=GetDataForCmb1";
  ///ofy1
	var CTSex_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTSex&pClassQuery=GetDataForCmb1";
	Ext.QuickTips.init();
	
	Ext.form.Field.prototype.msgTarget = 'qtip';
	
	// 不对图片进行压缩，直接转成base64
    /*function directTurnIntoBase64(fileObj,callback){
        var r = new FileReader();
        // 转成base64
        r.onload = function(){
           //变成字符串
            imgBase64 = r.result;
            callback(imgBase64);
        }
        r.readAsDataURL(fileObj);    //转成Base64格式
    }
    // 图片转base64方法
 	function canvasDataURL(path, obj, callback){
       	var image = new Image();        
		image.onload=function(){  
			var square = obj.pixel,   //定义画布的大小，也就是图片压缩之后的像素
			quality = 0.7 ,// 默认图片质量为0.7
			canvas = document.createElement('canvas'), 
			context = canvas.getContext('2d'),
			imageWidth = 0,    //压缩图片的大小
			imageHeight = 0, 
			offsetX = 0, 
			offsetY = 0,
			data = ''; 
			// 图像质量
			if (obj.quality && obj.quality <= 1 && obj.quality > 0) {
				quality = obj.quality
			}
			if(square){
			    canvas.width = square;  
			    canvas.height = square; 
			    context.clearRect(0, 0, square, square); 
			    if (this.width > this.height) {  
			        imageWidth = Math.round(square * this.width / this.height);  
			        imageHeight = square;  
			        offsetX = - Math.round((imageWidth - square) / 2);  
			    } else {  
			        imageHeight = Math.round(square * this.height / this.width);  
			        imageWidth = square;  
			        offsetY = - Math.round((imageHeight - square) / 2);  
			    }  
			} else{
				canvas.width = this.width;  
			    canvas.height = this.height; 
			    imageWidth=this.width;
			    imageHeight=this.height;
			}
			context.drawImage(this, offsetX, offsetY, imageWidth, imageHeight);  
			data = canvas.toDataURL('image/jpeg',quality);  
			//压缩完成执行回调  
			callback(data);  
		}
		image.src=path;  
 	}
 	// 压缩图片函数的回调方法, 用户设置界面显示图片
 	function setImg(urlDate, fileObj, obj) {
 		if (urlDate.length > 60000) {
			var percentage=urlDate.length / 60000
			if (!obj.quality) {
				obj.quality = 0.7
			} 
			if(obj.quality > 0.2){
				obj.quality = obj.quality / percentage
				if(obj.quality<0.2) obj.quality = .2
				compress(fileObj, obj, function(base64Codes) {
				  setImg(base64Codes, fileObj, obj)
				})
			}else{
				if (obj.pixel && obj.pixel>300) {
					obj.pixel = obj.pixel / percentage
				} else {
					obj.pixel = 1000
				}
				compress(fileObj, obj, function(base64Codes) {
				  setImg(base64Codes, fileObj, obj)
				})
			}
			
		} else {
	        var img= Ext.getCmp('browseImage').getEl().dom
	        img.src = urlDate; //显示预览图片
	        if(obj.orientation==3){
				img.style.transform = 'rotate(180deg)';
	        	Ext.getCmp("SSUSREImgOrientationF").setValue('180deg');
	        }else if(obj.orientation==6){
				img.style.transform = 'rotate(90deg)';
	        	Ext.getCmp("SSUSREImgOrientationF").setValue('90deg');
	        }else if(obj.orientation==8){
				img.style.transform = 'rotate(-90deg)';
	        	Ext.getCmp("SSUSREImgOrientationF").setValue('-90deg');
	        }else{
	        	img.style.transform = 'rotate(0deg)';
	        	Ext.getCmp("SSUSREImgOrientationF").setValue('0deg');
	        }
		}
	}
 	// 对图片进行压缩
    function compress(fileObj,obj, callback) { 
        if ( typeof (FileReader) === 'undefined') {  
            alert("当前浏览器内核不支持base64图标压缩");  
        } else {  
            try { 
                var reader = new FileReader();  
                reader.onload = function (e) {  
                	var re = this.result
                	canvasDataURL(re,obj,callback)    
                };  
                reader.readAsDataURL(fileObj);  
            }catch(e){  
                alert("压缩失败!");  
            }  
        }
    }*/
	var btnUpload = new Ext.Toolbar.Button({
        text: '头像上传',
        tooltip: '头像上传',
        iconCls: 'icon-DP',
        id:'btnUpaload',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnUpaload'),
      	handler: function() {		
			var link="dhc.bdp.uploadavator.csp?selectrow="+SSUSRRowId; 
			/** 用户扩展信息 */
			var winUpload = new Ext.Window({
				iconCls : 'icon-DP',
				width : 650,
				height : 480,
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
				onHide:function(){
					loadFormData()
				}
			});
			winUpload.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';
			winUpload.setTitle("头像上传");
			winUpload.show();
			
		}
      	
    });
	
	var WinForm = new Ext.FormPanel({
		id : 'form-save',
		title : '',
		region : 'center',
		labelAlign : 'right',
		labelWidth : 75,
		split : true,
		frame : true,
		waitMsgTarget : true,
		buttonAlign : 'center',
		reader: new Ext.data.JsonReader({root:'list'},
				[
				 {name: 'SSUSRERowId',mapping:'SSUSRERowId',type : 'string'},
				 {name: 'SSUSREBirthday',mapping:'SSUSREBirthday',type : 'string'},
				 {name: 'SSUSRECountryDR',mapping:'SSUSRECountryDR',type : 'string'},
				 {name: 'SSUSRENationDR',mapping:'SSUSRENationDR',type : 'string'},
				// {name: 'SSUSRESexDR',mapping:'SSUSRESexDR',type : 'string'},   //ofy1
				 {name: 'SSUSREMaritalDR',mapping:'SSUSREMaritalDR',type : 'string'},
				 {name: 'SSUSREEducationDR',mapping:'SSUSREEducationDR',type : 'string'},
				 {name: 'SSUSREAddress',mapping:'SSUSREAddress',type : 'string'},
				 {name: 'SSUSRESerialNo',mapping:'SSUSRESerialNo',type : 'string'},
				 {name: 'SSUSRECertificateNo',mapping:'SSUSRECertificateNo',type : 'string'},
				 {name: 'SSUSREPoliticalStatus',mapping:'SSUSREPoliticalStatus',type : 'string'},
				 {name: 'SSUSREIntroduction',mapping:'SSUSREIntroduction',type : 'string'},
				 {name: 'SSUSRESpeciality',mapping:'SSUSRESpeciality',type : 'string'},
				 {name: 'SSUSREText1',mapping:'SSUSREText1',type : 'string'},
				 {name: 'SSUSREText2',mapping:'SSUSREText2',type : 'string'},
				 {name: 'SSUSREImgOrientation',mapping:'SSUSREImgOrientation',type : 'string'}
				 
				]),
		items : [{
				xtype:'fieldset',
				title:'',
				items :[{
					baseCls : 'x-plain',
					layout:'column',
					border:false,
					items:[{
						baseCls : 'x-plain',
						columnWidth:'.3',
						layout: 'form',
						labelWidth: 60,
						labelPad:1,//默认5
						border:false,
						defaults: {anchor:'96%',msgTarget:'under'},
						items: [{  
							xtype : 'box',  
							id : 'browseImage',  
							autoEl : {  
								width : 200,  
								height : 190,  
								tag : 'img',  
								src : Ext.BLANK_IMAGE_URL,  
								style : 'border : 1px solid #999;',  
								id : 'imageBrowse' 
							}  
						},btnUpload]					
					},{
						baseCls : 'x-plain',
						columnWidth:'.7',
						layout: 'form',
						labelWidth: 80,
						labelPad:1,//默认5
						border:false,
						defaults: {anchor:'96%',msgTarget:'under'},
						items: [{
							xtype:'textarea',
							fieldLabel: "职工简介",
							width:280,
							name: 'SSUSREIntroduction',
							id:'SSUSREIntroduction',
					        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREIntroduction')),	
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREIntroduction'),
							dataIndex:'SSUSREIntroduction',
							height : 130
						},{
							xtype:'textarea',
							fieldLabel: "职工特长",
							width:280,
							name: 'SSUSRESpeciality',
							id:'SSUSRESpeciality',
					        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRESpeciality')),	
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRESpeciality'),
							dataIndex:'SSUSRESpeciality',
							height : 75
						}]					
					}]
				}]
			},{
				xtype:'fieldset',
				title:'用户扩展信息维护',
				labelWidth: 90,
				autoHeight:true,
				items :[{
					baseCls : 'x-plain',
					layout:'column',
					border:false,
					items:[{
						baseCls : 'x-plain',
						columnWidth:'.5',
						layout: 'form',
						labelWidth: 100,
						labelPad:1,//默认5
						border:false,
						defaults: {anchor:'96%',msgTarget:'under'},
						items: [{
							xtype:'datefield',
					        fieldLabel: '出生日期',
					        name: 'SSUSREBirthday',
					        id:'SSUSREBirthdayF',
					        enableKeyEvents : true, 
					        readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREBirthdayF'),
					        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREBirthdayF')),
							format : BDPDateFormat,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
					    },{
						 	xtype:'bdpcombo',
							fieldLabel: "国籍",
							loadByIdParam : 'rowid',
							pageSize:Ext.BDP.FunLib.PageSize.Combo,
							id:'SSUSRECountryDRF',
							name: 'SSUSRECountryDR',
							hiddenName:'SSUSRECountryDR',//不能与id相同
							queryParam : 'desc',
							forceSelection: true,
							selectOnFocus:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRECountryDRF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRECountryDRF')),
							mode:'remote',
							listWidth:250,
							valueField:'CTCOURowId',
							displayField:'CTCOUDesc',
							store:new Ext.data.JsonStore({
								url:CTCountry_QUERY_ACTION_URL,
								root: 'data',
								totalProperty: 'total',
								idProperty: 'CTCOURowId',
								fields:['CTCOURowId','CTCOUDesc']
							})
					    },{
							xtype:'bdpcombo',
							fieldLabel: "民族",
							loadByIdParam : 'rowid',
							pageSize:Ext.BDP.FunLib.PageSize.Combo,
							id:'SSUSRENationDRF',
							name: 'SSUSRENationDR',
							hiddenName:'SSUSRENationDR',//不能与id相同
							queryParam : 'desc',
							forceSelection: true,
							selectOnFocus:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRENationDRF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRENationDRF')),
							mode:'remote',
							listWidth:250,
							valueField:'CTNATRowId',
							displayField:'CTNATDesc',
							store:new Ext.data.JsonStore({
								url:CTNation_QUERY_ACTION_URL,
								root: 'data',
								totalProperty: 'total',
								idProperty: 'CTNATRowId',
								fields:['CTNATRowId','CTNATDesc']
							})
					    },{	
					    	xtype:'bdpcombo',
							fieldLabel: "婚姻状况",
							id:'SSUSREMaritalDRF',
							loadByIdParam : 'rowid',
							pageSize:Ext.BDP.FunLib.PageSize.Combo,
							name: 'SSUSREMaritalDR',
							hiddenName:'SSUSREMaritalDR',//不能与id相同
							queryParam : 'desc',
							forceSelection: true,
							selectOnFocus:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREMaritalDRF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREMaritalDRF')),
							mode:'remote',
							listWidth:250,
							valueField:'CTMARRowId',
							displayField:'CTMARDesc',
							store:new Ext.data.JsonStore({
								url:CTMarital_QUERY_ACTION_URL,
								root: 'data',
								totalProperty: 'total',
								idProperty: 'CTMARRowId',
								fields:['CTMARRowId','CTMARDesc']
							})
					    },{	
					    	xtype:'bdpcombo',
							fieldLabel: "教育水平",
							id:'SSUSREEducationDRF',
							loadByIdParam : 'rowid',
							pageSize:Ext.BDP.FunLib.PageSize.Combo,
							name: 'SSUSREEducationDR',
							hiddenName:'SSUSREEducationDR',//不能与id相同
							queryParam : 'desc',
							forceSelection: true,
							selectOnFocus:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREEducationDRF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREEducationDRF')),
							mode:'remote',
							listWidth:250,
							valueField:'EDURowId',
							displayField:'EDUDesc',
							store:new Ext.data.JsonStore({
								url:CTEducation_QUERY_ACTION_URL,
								root: 'data',
								totalProperty: 'total',
								idProperty: 'EDURowId',
								fields:['EDURowId','EDUDesc']
							})
						///ofy1
					    /*},{		
					    	xtype:'bdpcombo',
							fieldLabel: "性别",
							id:'SSUSRESexDRF',
							loadByIdParam : 'rowid',
							pageSize:Ext.BDP.FunLib.PageSize.Combo,
							name: 'SSUSRESexDR',
							hiddenName:'SSUSRESexDR',//不能与id相同
							queryParam : 'desc',
							forceSelection: true,
							selectOnFocus:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRESexDRF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRESexDRF')),
							mode:'remote',
							listWidth:250,
							valueField:'CTSEXRowId',
							displayField:'CTSEXDesc',
							store:new Ext.data.JsonStore({
								url:CTSex_QUERY_ACTION_URL,
								root: 'data',
								totalProperty: 'total',
								idProperty: 'CTSEXRowId',
								fields:['CTSEXRowId','CTSEXDesc']
							})
						*/
						},{	
					    	xtype:'combo',
							fieldLabel: "政治面貌",
							id:'SSUSREPoliticalStatusF',
							name: 'SSUSREPoliticalStatus',
							hiddenName:'SSUSREPoliticalStatus',
							forceSelection: true,
							selectOnFocus:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREPoliticalStatusF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREPoliticalStatusF')),
							mode:'local',
							triggerAction : 'all',
							listWidth:250,
							valueField : 'value',
							displayField : 'name',
							store : new Ext.data.JsonStore({
								fields : ['name', 'value'],
								data : [{
											name : '中共党员',value : '中共党员'
										}, {
											name : '中共预备党员',value : '中共预备党员'
										}, {
											name : '共青团员',value : '共青团员'
										}, {
											name : '民革党员',value : '民革党员'
										}, {
											name : '民盟盟员',value : '民盟盟员'
										}, {
											name : '民建会员',value : '民建会员'
										}, {
											name : '民进会员',value : '民进会员'
										}, {
											name : '农工党党员',value : '农工党党员'
										}, {
											name : '致公党党员',value : '致公党党员'
										}, {
											name : '九三学社社员',value : '九三学社社员'
										}, {
											name : '台盟盟员',value : '台盟盟员'
										}, {
											name : '无党派人士',value : '无党派人士'
										}, {
											name : '群众',value : '群众'
										}]
							})
					    },{
							
							xtype:'textfield',
							fieldLabel: "SSUSRERowId",
							name: 'SSUSRERowId',
							id:'SSUSRERowId',
							hideLabel : 'True',
							hidden : true
						}]					
					},{
						baseCls : 'x-plain',
						columnWidth:'.5',
						layout: 'form',
						labelWidth: 100,
						labelPad:1,
						border:false,
						defaults: {anchor:'96%',xtype: 'textfield',msgTarget:'under'},
						items: [{
								xtype: 'textfield',
								fieldLabel: "职工号",
								name: 'SSUSRESerialNo',
								id:'SSUSRESerialNo',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRESerialNo')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRESerialNo'),
								dataIndex:'SSUSRESerialNo'
							},{
								xtype: 'textfield',
								fieldLabel: "证书编号",
								name: 'SSUSRECertificateNo',
								id:'SSUSRECertificateNo',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRECertificateNo')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRECertificateNo'),
								dataIndex:'SSUSRECertificateNo'
							},{
								xtype: 'textfield',
								fieldLabel: "家庭住址",
								name: 'SSUSREAddress',
								id:'SSUSREAddress',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREAddress')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREAddress'),
								dataIndex:'SSUSREAddress'
							},{
								xtype: 'textfield',
								fieldLabel: "Text1",
								name: 'SSUSREText1',
								id:'SSUSREText1',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREText1')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREText1'),
								dataIndex:'SSUSREText1'
								
							/*
							//ofy1 烟台医保对照数据传输
							 },{	
								xtype:'combo',
								fieldLabel: "人员类别",
								id:'SSUSREText1F',
								name: 'SSUSREText1',
								hiddenName:'SSUSREText1',
								forceSelection: true,
								selectOnFocus:false,
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREText1F'),
								style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREText1F')),
								mode:'local',
								triggerAction : 'all',
								listWidth:250,
								valueField : 'value',
								displayField : 'name',
								store : new Ext.data.JsonStore({
									fields : ['name', 'value'],
									data : [{
												name : '执业医师',value : '11-执业医师'
											}, {
												name : '执业助理医师',value : '12-执业助理医师'
											}, {
												name : '见习医师',value : '13-见习医师'
											}, {
												name : '注册护士',value : '21-注册护士'
											}, {
												name : '助产士',value : '22-助产士'
											}, {
												name : '西药师（士）',value : '31-西药师（士）'
											}, {
												name : '中药师（士）',value : '32-中药师（士）'
											}, {
												name : '检验技师（士）',value : '41-检验技师（士）'
											}, {
												name : '影像技师（士）',value : '42-影像技师（士）'
											}, {
												name : '卫生监督员',value : '50-卫生监督员'
											}, {
												name : '其他卫生技术人员',value : '69-其他卫生技术人员'
											}, {
												name : '其他技术人员',value : '70-其他技术人员'
											}, {
												name : '管理人员',value : '80-管理人员'
											}, {
												name : '工勤及技能人员',value : '90-工勤及技能人员'
											}]
								})*/
    
							},{
								xtype: 'textfield',
								fieldLabel: "Text2",
								//fieldLabel: "身份证号", //ofy1 烟台医保对照数据传输
								name: 'SSUSREText2',
								id:'SSUSREText2',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREText2')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREText2'),
								dataIndex:'SSUSREText2'
							},{           	
								xtype: 'textfield',
								fieldLabel : 'SSUSREImgOrientation',
								hideLabel : 'True',
								hidden : true,
								id:'SSUSREImgOrientationF',
								name : 'SSUSREImgOrientation'
							}]						
					}]
				}]
			}],
		buttons:[{
			text : '保存',
			iconCls : 'icon-save',
			handler : function() {
				WinForm.form.submit({
					clientValidation : true, // 进行客户端验证
					waitMsg : '正在提交数据请稍后...',
					waitTitle : '提示',
					url : SSUSRE_SAVE_ACTION_URL,
					params:{'img':Ext.getCmp('browseImage').getEl().dom.src},
					method : 'POST',
					success : function(form, action) {
						if (action.result.success == 'true') {
							var myrowid = action.result.id;
							// var myrowid = jsonData.id;
							Ext.Msg.show({
										title : '提示',
										msg : '保存成功!',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK,
										fn : function(btn) {
											
										}
							});
						} else {
							var errorMsg = '';
							if (action.result.errorinfo) {
								errorMsg = '<br/>错误信息:' + action.result.errorinfo
							}
							Ext.Msg.show({
										title : '提示',
										msg : '保存失败!' + errorMsg,
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
						}

					},
					failure : function(form, action) {
						Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
					}
				})
			}
		}
		
		]
	})

   // 载入被选择的数据行的表单数据
    var loadFormData = function() {
        WinForm.form.load( {
            url : SSUSRE_OPEN_ACTION_URL + '&id='+ SSUSRRowId,
            //waitMsg : '正在载入数据...',
            success : function(form,action) {
            	//Ext.Msg.alert('编辑','载入成功！');
            	var imgdata=tkMakeServerCall("web.DHCBL.CT.SSUserExtend","getImg",SSUSRRowId)
            	
            	if(imgdata!=""){
            		Ext.getCmp('browseImage').getEl().dom.src=imgdata
            		var Orientation=tkMakeServerCall("web.DHCBL.CT.SSUserExtend","getImgOrientation",SSUSRRowId)
            		Ext.getCmp('browseImage').getEl().dom.style.transform = 'rotate('+Orientation+')';
            	}else{
            		Ext.getCmp('browseImage').getEl().dom.src='../scripts/bdp/Framework/imgs/null.jpg';
            	}
            	
            },
            failure : function(form,action) {
            	Ext.Msg.alert('编辑','载入失败！');
            }
        });
    };
    loadFormData()
    
	//创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [WinForm]
	});

});