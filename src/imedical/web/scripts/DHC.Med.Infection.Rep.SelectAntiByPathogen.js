//DHC.Med.Infection.Rep.SelectAntiByPathogen  通过设置的病原体试剂盒分批的选择抗生素
//Create by cjb 20090827
function SelectAntiByPathogen(objParent,evHandler,InfPathogen)
{
	var obj=new Object();
	var objArry = QueryAntiDicByPy("MethodQueryAntiDicByPy", "MethodQueryAntiDicByPyList", "",InfPathogen.Resume,"Y");  //20090828
	var selCheckColumn=new Ext.grid.CheckColumn({header:Checked,dataIndex:'checked',width:55,hidden:true});
	var selSenCkCol=new Ext.grid.CheckColumn({header:Sen,dataIndex:'Sen',width:55});
	//var cboSen = new Ext.form.ComboBox({fieldLabel:Sen,editable:false,mode: 'local', triggerAction: 'all',store:CreateDicDataStore("InfectionLabSenCheck"),displayField:"Description",valueField:"Code",width:80});
	//EditorGridPanel
	obj.gridAntiByPathogen=new Ext.grid.EditorGridPanel({
		store:new Ext.data.SimpleStore({
			fields:[
			{name:'RowID'},
			{name:'Code'},
			{name:'AntiName'},
			{name:'Sen'},
			{name:'checked'},
			{name:'objDic'}
			]
			}),
		columns:[
		new Ext.grid.RowNumberer(),
		{id:'RowID',header:"Code",width:75,sortable:false,dataIndex:'Code'},
		{header:AntiDrug,width:175,sortable:false,dataIndex:'AntiName'},
		//selSenCkCol,
		{       header: Sen,
            dataIndex: 'Sen',
            width: 130,
            editor: new Ext.form.ComboBox({
                allowBlank:false,
                typeAhead: true,
                triggerAction: 'all',
                mode: 'local',store:CreateDicDataStore("InfectionLabSenCheck"),displayField:"Description",valueField:"Code",
                //lazyRender: true,
                listClass: 'x-combo-list-small'
            })
        },
        selCheckColumn

		],
		stripeRows:true,
		plugins:[selCheckColumn],
		height:300,
		width:450,
		clicksToEdit: 1
		});
	var objPanel=({
		xtype:'fieldset',
		frame:true,
		width:500,
		layout:"form",
		items:[
		obj.gridAntiByPathogen
		]	
		});
	obj.Win=new Ext.Window({
		title:GermSenTitle,
		width:500,
		heigth:400,
		closeAction:'hide',
		plain: true,
		modal:true,
		items:[
		new Ext.FormPanel(objPanel)
		],
		buttons:
		[
		{
			text:strOK,
		handler:function()
		{
			 var selFlag=false;
			 var objData=null;
			 var objStore = obj.gridAntiByPathogen.getStore();
			 for(var j=0;j<objStore.getCount();j++)
			 {
			 	  objData=objStore.getAt(j);
			 	  if(!objData.get("checked"))
			 	    continue;	
			 	  if(objData.get("objDic")==null)
			 	    continue;
			 	  if(evHandler != null)
					{
						//var objGerm = GetDicComboValue(obj.cboGerm)
						objParent.cboSen.setValue(objData.get("Sen"));
						evHandler.call(objParent,InfPathogen,objData.get("objDic"),GetDicComboValue(objParent.cboSen));
						if(!selFlag)selFlag=true;
					}
			 	}
			 	if(selFlag)
			 	  obj.Win.hide();
			 	else
			 		Ext.Msg.alert(Notice, PleaseChooseItem);				
			}
		},
		{
			text:Cancel,
	    handler:function(){obj.Win.hide();} 
			}
		]
		});
		obj.DisplayAnti=function(arry)
		{
			var objRec=null;
			var objAnti=null;
			 for(var i = 0; i < arry.length ; i ++)
  		 {
  		 	objAnti=arry[i];
  		 	objRec=new Ext.data.Record({
  		 		RowID:"",
  		 		Code:objAnti.Code,
  		 		AntiName:objAnti.Desc,
  		 		Sen:"Y",
  		 		checked:true,
  		 		objDic:objAnti
  		 		});
  		 		obj.gridAntiByPathogen.getStore().add([objRec]);
  		 }
		}
		if(objArry!=null)
		  obj.DisplayAnti(objArry);
		return obj;
}
