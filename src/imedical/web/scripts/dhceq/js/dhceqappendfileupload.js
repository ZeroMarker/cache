//GR0046 extjs �ļ��ϴ�
//�ļ��ϴ������ϴ��������
//����csp��dhceq.process.AppendFile.csp
//=========================�Ӵ���=============================
function CreateAppendFileuploadWin(AppendFileData)
{
	var AFformAppendFile=	new Ext.dhceq.AppendFileTypeComboBox({id:'AFformAppendFile',hiddenName:'AppendFileTypeDR'});
	AFformAppendFile.store.load(
			{params:{start:0,limit:20},
			callback : function(r, options, success) {
				SetAppendFileInfo()
			},
			scope: CreateAppendFileuploadWin, //Scope����ָ���ص�����ִ��ʱ��������
           	//AddΪtrueʱ��load()�õ������ݻ������ԭ����store���ݵ�ĩβ��
          	//����������֮ǰ�����ݣ��ٽ��õ���������ӵ�store��
����add: false //ensemble��js�������Կհ״���̫����
	})
	var AFformDocName=	new Ext.form.TextField({		
					id:'AFformDocName',
					name:'DocName',
					fieldLabel: '��������',
					selectOnFocus:true
				  }); 		           	
	var AFformRemark=	new Ext.form.TextField({		
					id:'AFformRemark',
					name:'Remark',
					fieldLabel: '��ע',
					selectOnFocus:true
				  });
				  
	//============================���==========================

	
	//�������
	var AFformPanel = new Ext.form.FormPanel({
	labelwidth : 30,
	autoScroll:true,
	//Height:500,
	labelAlign : 'right',
	frame : true,
	bodyStyle : 'padding:5px;',
	fileUpload:true, 	
    items : [{
		//xtype : 'fieldset',
		//title : '�ϴ�ѡ��',
		autoHeight : true,
		//layout : 'column',			
		items : [{
				layout : 'column',
				items : [
					{columnWidth : .33,layout:'form',items :AFformAppendFile},
					{columnWidth : .33,layout:'form',items :AFformDocName},
					{columnWidth : .33,layout:'form',items :AFformRemark}
					
				]},{
				layout : 'column',
				items : [
				{
					columnWidth : .46,
					//width:300,
					style : 'margin:0px 0px 0px 4%;',//{top:0, right:0, bottom:0, left:0}
					xtype: 'textfield',   
					fieldLabel: '�� ��',   
					name: 'FileStream' ,  
					inputType: 'file',  
					//allowBlank: false,   
					blankText: '���ϴ��ļ�',   
					anchor: '90%' 
					}
				]},{
				layout : 'column',
				items : [{
					style : 'margin:0px 0px 0px 5%;',
					xtype: 'button',//Ϊ�˷������Ƕ�ף�buttonҪд��items��[]���治��д��button��[]����
					iconCls:'page_edit',
					text: '����',
					handler:formhandler //����Ensemble��js�༭��Ч�ʵ��£�������������Ƶ�����
				}
				]
				}
		]
	}]
});
	function formhandler() 
	{
		var form = this.findParentByType("form").getForm();
		var RowID ="",SourceType=CurrentSourceType,SourceID=CurrentSourceID
		if (undefined!=AppendFileData.TRowID) {RowID = AppendFileData.TRowID;SourceType=AppendFileData.TSourceType;SourceID=AppendFileData.TSourceID}
		if(form.isValid()){
			form.submit({
				url: '../csp/dhceq.process.appendfileaction.csp?&actiontype=UploadByFtpStream&RowID='+RowID+'&SourceType='+SourceType+'&SourceID='+SourceID,		//3.3�汾URlд������
				waitMsg: 'Uploading your file...',
				success: function(form, action)
				{
					Msg.info("",'Success' + action.result.result)
					UpdateForAppendFileChange()
					//PicListGrid.store.load({params:{start:0,limit:PicListPagingToolbar.pageSize}})
				},
				failure: function(form, action) 
				{
					Msg.info("error",'failure'  + action.result.result)
				}
			});
			
		}
		else Msg.info("error","����ȫ")
	}
	//========================����========================
	
	//��ʼ������
	var AFSimpleuploadwindow = new Ext.Window({
		title:'���ļ���Ϣ',
		width:800,
		height:200,
		minWidth:600,
		minHeight:400,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle :'overflow-x:hidden;overflow-y:scroll',//����ˮƽ��������ֹ����ͼƬʱ�ڲ����̫��
		items:[AFformPanel],
		
		listeners:{
			'close':function(){
				}
			}
	});
	
	
	AFSimpleuploadwindow.show();	//��window�Ŀؼ�����д��һ��js�����в�ͨ������������������Լ��ɵ�windowFramԪ��û����ȫɾ���й�
	//==============================���ܺ���==================================
	function SetAppendFileInfo()
	{
		if (AppendFileData!="")
		{
			
			Ext.getCmp('AFformAppendFile').setValue(AppendFileData.TAppendFileTypeDR)
			Ext.getCmp('AFformDocName').setValue(AppendFileData.TDocName)
			Ext.getCmp('AFformRemark').setValue(AppendFileData.TRemark)
		}
	}
}
