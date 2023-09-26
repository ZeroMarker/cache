//GR0033 extjs 图片上传
//创建图片上传模态窗口
//关联csp：dhceq.process.picture.csp
//=========================子窗口=============================
function CreatePicuploadWin(PictureData,PiclistData)
{
	var TSourceType=PictureData.TSourceType
	//==========================================控件=====================================
	var PicformPicType=	new Ext.dhceq.PicTypeComboBox({id:'PicformPicType',hiddenName:'PicTypeDR',SourceType:CurrentSourceType,allowBlank:false});
	PicformPicType.store.load(
			{params:{start:0,limit:20},
			callback : function(r, options, success) {
				SetPictureInfo()
			},
			scope: CreatePicuploadWin, //Scope用来指定回调函数执行时的作用域
           	//Add为true时，load()得到的数据会添加在原来的store数据的末尾，
          	//否则会先清除之前的数据，再将得到的数据添加到store中
　　add: false //ensemble的js编译器对空白处理不太给力
	})
var PicformPicNo=	new Ext.form.TextField({		
					id:'PicformPicNo',
					name:'PictureNo',
					fieldLabel: '图片编号',
					selectOnFocus:true
				  }); 
var PicformPicName=	new Ext.form.TextField({		
					id:'PicformPicName',
					name:'PicName',
					fieldLabel: '图片名称',
					allowBlank:false,
					selectOnFocus:true
				  });			           	
var PicformRemark=	new Ext.form.TextField({		
					id:'PicformRemark',
					name:'Remark',
					fieldLabel: '备注',
					selectOnFocus:true
				  });
var PicformLocation=	new Ext.form.TextField({		
					id:'PicformLocation',
					name:'Location',
					fieldLabel: '存放位置',
					selectOnFocus:true
				  });
var PicformSort=new Ext.form.NumberField({
	id:'PicformSort',
	name:'PicSort',
    fieldLabel:"序号",
    allowDecimals:false,  //不允许输入小数
    nanText:"请输入有效数字", //无效数字提示
    allowNegative:false       //不允许输入负数
    ,width : 100,
    allowBlank:false,       //不允许为空        modified by czf 需求号：357126
    disabled:""!=PictureData,
	listWidth : 100,
	textWidth:100
   })
var PicformDefaultFlagField = new Ext.form.Checkbox({
	id : "PicformDefaultFlagField",
	name : "DefaultFlag",
	boxLabel : "默认显示",
	inputValue : "Y",
	height:40,
	anchor : "90%",
	hideLabel : true
	//为checkbox添加选中事件
}); 
	
//============================面板==========================

	
	//布局面板
	var PicformPanel = new Ext.form.FormPanel({
	labelwidth : 30,
	autoScroll:true,
	//Height:500,
	labelAlign : 'right',
	frame : true,
	bodyStyle : 'padding:5px;',
	fileUpload:""==PictureData, 	//3.3版本必须设置这个属性，4.2似乎不用
    items : [{
		//xtype : 'fieldset',
		//title : '上传选项',
		//autoHeight : true,
		//layout : 'column',
		// add by zx 20190107 测试组需求 需求号:773586 			
		items : [{
				layout : 'column',
				items : [
					{columnWidth : .50,layout:'form',items :PicformPicName,height:40},
					{columnWidth : .50,layout:'form',items :PicformPicType,height:40}
					
				]},{
				layout : 'column',
				items : [
					{columnWidth : .50,layout:'form',items :PicformPicNo,height:40},
					{columnWidth : .50,layout:'form',items :PicformRemark,height:40}
					
				]},{
				layout : 'column',
				items : [
					{columnWidth : .50,layout:'form',items :PicformLocation,height:40},
					{columnWidth : .15,layout:'form',items :PicformDefaultFlagField,height:40},
					{columnWidth : .35,layout:'form',items :PicformSort,height:40}
				]},{
				layout : 'column',
				hidden:""!=PictureData,
				items : [
				{
					columnWidth : .55,
					//width:300,
					style : 'margin:0px 0px 0px 4%;',//{top:0, right:0, bottom:0, left:0}
					xtype: 'textfield',   
					fieldLabel: '文 件',   
					name: 'FileStream' ,  
					inputType: 'file',  
					disabled:""!=PictureData,
					allowBlank: false,  //modify by lmm 2017-07-17 413570
					blankText: '请上传文件',   
					anchor: '90%' 
					}	//,{columnWidth : .13,layout:'form',items :PicformDefaultFlagField}//{width:100,items :PicformSort}//,{columnWidth : .66,layout:'form',width:100,items :checkboxModule}
					
				]},{
				layout : 'column',
				items : [{
					disabled:(TSourceType!=CurrentSourceType)&&(PictureData!=""),
					style : 'margin:10px 0px 0px 5%;',
					xtype: 'button',//为了方便面板嵌套，button要写在items：[]里面不能写在button：[]里面
					iconCls:'page_edit',
					text: '保存',
					handler:formhandler //由于Ensemble的js编辑器效率低下，所以这个函数移到外面
				}
				]
				}
		]
	}]
});
	function formhandler() 
	{
		var form = this.findParentByType("form").getForm();
		var PLRowID ="",PTRowID =""
		if (undefined!=PictureData.TRowID) PTRowID = PictureData.TRowID
		if (undefined!=PicListGrid.TRowID) PLRowID = PiclistData.TRowID;
		if(form.isValid()){
			form.submit({
				url: '../csp/dhceq.process.pictureaction.csp?&actiontype=UploadByFtpStream&SourceType='+CurrentSourceType+'&SourceID='+CurrentSourceID+'&PTRowID='+PTRowID+'&PLRowID='+PLRowID+'&EquipDR='+EquipDR,		//3.3版本URl写在这里
				waitMsg: 'Uploading your file...',
				success: function(form, action)
				{
					Msg.info("",'Success' + action.result.result)
					UpdateForPicChange()
					PicSimpleuploadWinwindow.close();  // And By QW20180312 需求号545974,545983
					//PicListGrid.store.load({params:{start:0,limit:PicListPagingToolbar.pageSize}})
				},
				failure: function(form, action) 
				{
					Msg.info("error",'failure'  + action.result.result)
				}
			});
			
		}
		else Msg.info("error","表单不全")
	}
	//========================窗体========================
	
	//初始化窗口
	var PicSimpleuploadWinwindow = new Ext.Window({
		title:'主图片信息',
		width:800,  // add by zx 20190107 测试组需求 需求号:773586 
		height:250,
		minWidth:600,
		minHeight:400,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle :'overflow-x:hidden;overflow-y:scroll',//禁用水平滚动条防止插入图片时内部面板太宽
		items:[PicformPanel],
		
		listeners:{
			'close':function(){
				}
			}
	});
	
	
	PicSimpleuploadWinwindow.show();	//将window的控件单独写在一个js方法行不通，估计与变量作用域以及旧的windowFram元素没有完全删除有关
	//==============================功能函数==================================
	function SetPictureInfo()
	{
		if (PictureData!="")
		{
			Ext.getCmp('PicformPicType').setValue(PictureData.TPicTypeDR)
			Ext.getCmp('PicformPicNo').setValue(PictureData.TPicNo)
			Ext.getCmp('PicformLocation').setValue(PictureData.TPicLocation)
			Ext.getCmp('PicformRemark').setValue(PictureData.TRemark)
			Ext.getCmp('PicformPicName').setValue(PictureData.TPicName)
			Ext.getCmp('PicformSort').setValue(PictureData.PicformSort)
		}
	}
//========================初始化===========================

	
	
	
}
