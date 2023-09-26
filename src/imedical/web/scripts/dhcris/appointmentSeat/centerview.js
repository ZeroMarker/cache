var colsOfResource = 7;

//动态加载资源panel	
var resourcePanel = new Ext.Panel({  
        layout:'form', 
        border:true, 
        //frame:true,
        //autoScroll:true,
        //height:350,
        items:[]
});

var centerRegion = new Ext.FormPanel({
		title:"资源",
		//bodyStyle:'padding:10;',
		layout:"form",
		region:'center',
		frame:true,
		autoScroll:true,
		items:[
			//serviceOrderGrid,
			//pnButton,
			//timeSpanPanel,
			resourcePanel
		]
});




//检查项目fileldset
//id : 检查项目rowid+"^"+医嘱rowid
//title:医嘱名称+"  "+医嘱日期【自动预约】
function addExamItem()
{
	resourcePanel.removeAll();
	selScheduleId="";
	var selRecord = serviceOrderGrid.getSelectionModel().getSelections();
	//if (  selRecord==null  ||selRecord.length != 1)
	//alert(dateStore.getCount()*155+200);
	//加载检查项目
	
	//if ((selRecord.length==0)) //sunyi 20151029
	//    return;
	    
	resourcePanel.setWidth(colsOfResource*155+200);
	
	
	var orderList="";
	var bookDate="";
	var bookTime="";
	var orderNameList="";
	var orderDate="";
	var status="";
	var orderArray={};
	var arcItmDrList="";
	for ( var i =0 ; i<selRecord.length; i++)
	{
  		if ( !(selRecord[i].data.status == "正在申请" || selRecord[i].data.status == "" ||selRecord[i].data.status == "预约"))
		{
			//alert("1");
			return;
		}	
	    var arcItmDr = selRecord[i].data.arcItmDr;
	    if (arcItmDrList=="")
	    {
		    arcItmDrList=arcItmDr;
	    }
	    else
	    {
		    arcItmDrList=arcItmDrList+"@"+arcItmDr;
	    }
		var flag = selRecord[i].data.appointFlag;
		
		if (selRecord[i].data.status == "预约")
			status="预约";
		bookDate=selRecord[i].data.bookDate;
		bookTime=selRecord[i].data.bookTime;
		orderDate=selRecord[i].data.orderDate;
		
			
  		var OeorditemID=selRecord[i].data.oeOrdDr;
  		
	    var bodyCode=selRecord[i].data.BodyDr;
	    if ( orderArray[OeorditemID] == null)
	    {
	      orderArray[OeorditemID]=bodyCode;
	    }
	    else
	    {
	       orderArray[OeorditemID]=orderArray[OeorditemID]+","+bodyCode;
	    }
	}  	
	  	
	var orderBodyList="";
	for(var key in orderArray)
	{  
		//alert(key+"$"+orderArray[key]);
		var orderlist;
		if(orderArray[key]!="")
		{
			orderlist=key+"$"+orderArray[key];
		}
		else
		{
			orderlist=key;
		}
		if (orderBodyList=="")
		{
			orderBodyList=orderlist;
		}
		else
		{
			orderBodyList=orderBodyList+"@"+orderlist;
		}
		
	}
 	var labelInfo="";
 	var orderDesc=tkMakeServerCall("web.DHCRisCommFunctionEx","getOrderItemDesc",orderBodyList);
  	if (status == "预约")
	{
		labelInfo=orderDesc+ " (已预约到 "+bookDate+ " "+bookTime+")";
	}
	else
	{
		labelInfo=orderDesc;
	}
	//alert(labelInfo);
	
	var checkGroup = new Ext.form.FieldSet({
        xtype: 'fieldset',
        title: labelInfo,
        id:arcItmDrList+"^"+orderBodyList,
        //checkboxToggle:true,
        autoHeight: true,
        width:(colsOfResource*155+200),
        collapsed: true,   // initially collapse the group
        collapsible: true,
        //titleCollapse :true,
        items: [
        	]
	});
	
	//checkGroup.on('expand',expandExamItem);
	resourcePanel.add(checkGroup);
	resourcePanel.doLayout();
	checkGroup.on('expand',expandExamItem);
	checkGroup.expand();
}

//expand的检查项目fieldset Id
var g_examItemFieldSetId;

function expandExamItem()
{
	g_examItemFieldSetId=this.id;
	//alert(g_examItemFieldSetId);
	//alert(this.title);
	modalityStore.load();
}



var jsSet = false;
var selScheduleId="";

function checkSchedule()
{
	
	//alert(this.id);
	if ( jsSet)
	{
		jsSet =false;
		return;
	}
	
	
	//var selRecord = serviceOrderGrid.getSelectionModel().getSelections()
	//if (  selRecord==null  ||selRecord.length != 1)
	//	return;
		
	//var oeOrdDrSel=selRecord[0].data.oeOrdDr;
	
	var arcItmdr = this.id.split("^")[0];
	var arcItmDesc=this.name.split("^")[2].split("  ")[0];
	var timespan = this.boxLabel.split(" ")[0];
	var date=this.name.split("^")[0];
	var equipment=this.name.split("^")[1];
	var scheduleDr=this.id.split("^")[2];
	var oeOrdDr=this.id.split("^")[1];
	
	var selRecord = serviceOrderGrid.getSelectionModel().getSelections();
	for ( var i =0 ; i<selRecord.length; i++)
	{
  		
		if (selRecord[i].data.status == "预约")
		{
			alert("请先取消预约!");
			jsSet=true;
    		this.setValue(false);
    		return;
		}	
	}  	
	
    //alert(this.checked);
    /*
    var index = serviceOrderGrid.store.find('oeOrdDr',oeOrdDr);

    if (serviceOrderGrid.getStore().getAt(index).get('status')=="预约")
    {
    	var  shcduleDate=serviceOrderGrid.getStore().getAt(index).get('bookDate');
    	var  shcduleTime=serviceOrderGrid.getStore().getAt(index).get('bookTime');
    	var  shcduleIdOld=serviceOrderGrid.getStore().getAt(index).get('scheduleDr');
    	if (index >= 0)
    	{
    		var infoHint="此医嘱已经预约到"+shcduleDate+" "+shcduleTime+",是否转预约到"+date+" "+timespan+"?";
    		var r=confirm(infoHint);
    		if (r == true)
    		{
    			//alert("转预约!");
    			var infoParam=oeOrdDr+"^"+scheduleDr+"^"+admSchedule+"^"+appointmentInfo.Session.user_rowid+"^"+appointmentInfo.Local.IpAddr;;
    			var ret = tkMakeServerCall("web.DHCRisResApptSchudleSystem","ChangeBooked",infoParam);
				//alert(ret);
				if (ret==0)
				{
					alert("转预约成功!");
					this.disable();
					var divBox=this.positionEl;
					//alert(test.id);
					divBox.removeClass('x-item-disabled');
					divBox.addClass('my-chechbox-disabled');
					//成功后修改列表以及checkbox
					var oldCheckBox=Ext.getCmp(arcItmdr+"^"+oeOrdDr+"^"+shcduleIdOld);
					if ( oldCheckBox)
					{
						var divBox=oldCheckBox.positionEl;
						divBox.removeClass('my-chechbox-disabled');
						divBox.addClass('x-item-disabled');
						oldCheckBox.enable();
						jsSet=true;					
						oldCheckBox.setValue(false);
					}
					changeScheduleInfo(oeOrdDr);
					//this.enable();
					//return;
				}
				else
				{
					alert("转预约失败! ret="+ret);
					jsSet=true;
    				this.setValue(false);
				}
    			return;
    		}
    		else
    		{
    			jsSet=true;
    			this.setValue(false);
    			return;
    		}
    	}
    }
    */
    //alert(this.checked);
    
    if ( selScheduleId!="" && selScheduleId!=scheduleDr)
	{
 
		if (this.checked)
		{
			/*if (index >= 0)
			{
				serviceOrderGrid.getStore().getAt(index).set('scheduleDr',scheduleDr);
			}
			*/
			for ( var i =0 ; i<selRecord.length; i++)
			{
  				selRecord[i].set('scheduleDr',scheduleDr);
			}  
		}
		var oldCheckBox=Ext.getCmp(arcItmdr+"^"+oeOrdDr+"^"+selScheduleId);
		if (oldCheckBox)
		{
			jsSet=true;
			oldCheckBox.setValue(false);
		}
		selScheduleId=scheduleDr;
		return;
	}
	
	//alert(this.checked);
	if ( this.checked )
	{	
		//alert(index);
		/*
		if (index >= 0)
		{
			//selRecord[0].data.hasOccupy == 'Y'
			//serviceOrderGrid.getStore().getAt(index).set('checkboxId',this.id);
			serviceOrderGrid.getStore().getAt(index).set('scheduleDr',scheduleDr);
		}
		*/
		for ( var i =0 ; i<selRecord.length; i++)
		{
			selRecord[i].set('scheduleDr',scheduleDr);
		}  
		selScheduleId=scheduleDr;
	
	}
	else
	{
		//alert(index);
		/*if (index >= 0)
		{
			//serviceOrderGrid.getStore().getAt(index).set('checkboxId',"");
			serviceOrderGrid.getStore().getAt(index).set('scheduleDr',"");
		}
		*/
		for ( var i =0 ; i<selRecord.length; i++)
		{
			selRecord[i].set('scheduleDr',"");
		} 
		selScheduleId="";
	}
    
}


function changeScheduleInfo()
{
	
	var orderList="";
	var bookDate="";
	var bookTime="";
	var orderNameList="";
	var orderDate="";
	var status="";
	var orderArray={};
	var arcItmDrList="";
	var schDuleRowid="";
	
	var selRecord = serviceOrderGrid.getSelectionModel().getSelections();
	for ( var i =0 ; i<selRecord.length; i++)
	{			
  		var OeorditemID=selRecord[i].data.oeOrdDr;
	    var bodyCode=selRecord[i].data.BodyDr;
	    var scheduleInfo=tkMakeServerCall("web.DHCRisResourceApptSchudle","getBookDetailInfo",OeorditemID,bodyCode);
		var scheduleInfoArray=scheduleInfo.split("^");
		
		if (scheduleInfoArray.length==4)
		{
			//alert("change schdule info");
			selRecord[i].set('scheduleDr',scheduleInfoArray[0]);
			selRecord[i].set('bookRes',scheduleInfoArray[1]);
			selRecord[i].set('bookDate',scheduleInfoArray[2]);
			selRecord[i].set('bookTime',scheduleInfoArray[3]);
			selRecord[i].set('status','预约');
			//selRecord.set('isPrint',true);
		}
		else
		{
			selRecord[i].set('scheduleDr',"");
			selRecord[i].set('bookRes',"");
			selRecord[i].set('bookDate',"");
			selRecord[i].set('bookTime',"");
			selRecord[i].set('status',"");
		}
	}  	
	  	
	
	/*var index = serviceOrderGrid.store.find('oeOrdDr',oeOrdDr);
	if (index >= 0)
	{
		var scheduleInfo=tkMakeServerCall("web.DHCRisResApptSchudleSystem","GetBookedPrintData",oeOrdDr);
		var scheduleInfoArray=scheduleInfo.split("^");
		
		if (scheduleInfoArray.length>5)
		{
			//alert("change schdule info");
			serviceOrderGrid.getStore().getAt(index).set('scheduleDr',scheduleInfoArray[0]);
			serviceOrderGrid.getStore().getAt(index).set('bookRes',scheduleInfoArray[2]);
			serviceOrderGrid.getStore().getAt(index).set('bookDate',scheduleInfoArray[3]);
			serviceOrderGrid.getStore().getAt(index).set('bookTime',scheduleInfoArray[4]);
			serviceOrderGrid.getStore().getAt(index).set('status','预约');
			serviceOrderGrid.getStore().getAt(index).set('isPrint',true);
		}
	}
	*/
	
}



function addModalityScheduleOld()
{
	
	var arcItmFieldSet = Ext.getCmp(g_examItemFieldSetId);

	if( arcItmFieldSet )
	{
		arcItmFieldSet.removeAll();
		var oeOrdDr=g_examItemFieldSetId.split("^")[1];
		
		var length = modalityStore.getCount();
		if (length==0)
		{
			//alert("此时间段内没有可预约资源");
			arcItmFieldSet.collapse();
			return;
		}
		
	
		var m = 0;
		var modalityNow = "";
		var modalityDrNow = "";
		var modalityGroup =[];
		var modalityItems = [];
		var modalityNumber = 0;
		
		for (var n = 0 ; n< dateStore.getCount();n++)
		{
			var boxPanle = new Ext.Panel({
				width:155,
				items:[
					 {
						xtype:'displayfield',
						fieldLabel:''
					}
				]
			});
			modalityItems[n]= boxPanle;
		
		}
				
		var modalityDesc = "";
		var modalityDr = "";
		var scheduleDate = "";
		while (m < length)
		{
			modalityDesc = modalityStore.getAt(m).get('modalityDesc');
			scheduleDate = modalityStore.getAt(m).get('date');	
			modalityDr = modalityStore.getAt(m).get('modalityDr');
			if ( modalityNow == "")
			{
				modalityNow = modalityDesc;
				modalityDrNow = modalityDr;
			}
			if (modalityDrNow != modalityDr )
			{
				//插入一个资源
				addOneEquipment(modalityItems,modalityDrNow,modalityNow);
				var line = new Ext.chart.LineChart({
					height:1,
					//style:'border: 1px solid #8db2e3;'
					//bodyStyle:'padding:0 100 0 100',
					style:'background:none; border-right: 0px solid;border-top: 0px solid;border-left: 0px solid;border-bottom: #8db2e3 1px solid;'
				});
				arcItmFieldSet.add(line);
				arcItmFieldSet.doLayout();
				modalityDrNow = modalityDr;
				modalityNow = modalityDesc;
				//modalityItems.clear();
				modalityItems = [];	
				for (var n = 0 ; n< dateStore.getCount();n++)
				{
					var boxPanle = new Ext.Panel({
						width:155,
						items:[
							{
								xtype:'displayfield',
								fieldLabel:''
							}
						]
					});
					modalityItems[n]= boxPanle;
				
				}		
			}
			
			var index = dateStore.find('date',scheduleDate);
			if ( index >= 0 )
			{
				
					var checkbox = new Ext.form.Checkbox({
						boxLabel: modalityStore.getAt(m).get('timespan')+" "+modalityStore.getAt(m).get('number')+"/"+modalityStore.getAt(m).get('MaxNumber'),
						name: scheduleDate+"^"+modalityStore.getAt(m).get('modalityDesc')+"^"+arcItmFieldSet.title, 
						//checked:true,
						id:arcItmFieldSet.id+"^"+modalityStore.getAt(m).get('rowid'),
						disabled : ((modalityStore.getAt(m).get('view')=="N")?true:false),   //((modalityStore.getAt(m).get('number')==0)?true:false),
						inputValue:oeOrdDr  //modalityStore.getAt(m).get('rowid') 改为医嘱rowid
					});
				
					checkbox.on('check',checkSchedule);
					modalityItems[index].add(checkbox);
				
			}
			m=m+1;
			
		}
	
		addOneEquipment(modalityItems,modalityDr,modalityDesc);
	
		
		//如果有选中记录，则自动勾选
		var selInfo=getSelInfo();
		var checkboxId=selInfo[0];
		var status=selInfo[1];
		var scheduleDr=checkboxId.split("^")[2];
		//alert(scheduleDr);
		if (checkboxId!="")
		{
			var checkBoxObj=Ext.getCmp(checkboxId);
			if ( checkBoxObj != null)
			{
				jsSet=true;
				checkBoxObj.setValue(true);
				if (status=='预约')
				{
					checkBoxObj.disable();
			
					var divBox=checkBoxObj.positionEl;
					divBox.removeClass('x-item-disabled');
					divBox.addClass('my-chechbox-disabled');
					//alert(checkBoxObj.className);
					//alert("1");
					//resourcePanel.doLayout();
				}
				else
				{
					selScheduleId=scheduleDr;
				}
			}
		}	
		
		
	}
}

//获取选中信息，返回预约资源需选中的checkbox id
function getSelInfo()
{
	
	var orderList="";
	var bookDate="";
	var bookTime="";
	var orderNameList="";
	var orderDate="";
	var status="";
	var orderArray={};
	var arcItmDrList="";
	var schDuleRowid="";
	var selRecord = serviceOrderGrid.getSelectionModel().getSelections();
	var recLoc="";
	for ( var i =0 ; i<selRecord.length; i++)
	{
  		//if ( !(selRecord[i].data.status == "正在申请" || selRecord[i].data.status == "" ||selRecord[i].data.status == "预约"))
		//{
			//alert("1");
			//return;
		//}	
		status=selRecord[i].data.status;
	    var arcItmDr = selRecord[i].data.arcItmDr;
	    if (arcItmDrList=="")
	    {
		    arcItmDrList=arcItmDr;
	    }
	    else
	    {
		    arcItmDrList=arcItmDrList+"@"+arcItmDr;
	    }
		//var flag = selRecord[i].data.appointFlag;
		
		schDuleRowid=selRecord[i].data.scheduleDr;
		bookDate=selRecord[i].data.bookDate;
		bookTime=selRecord[i].data.bookTime;
		orderDate=selRecord[i].data.orderDate;
		recLoc=selRecord[i].data.recLocDr;
			
  		var OeorditemID=selRecord[i].data.oeOrdDr;
  		
	    var bodyCode=selRecord[i].data.BodyDr;
	    if ( orderArray[OeorditemID] == null)
	    {
	      orderArray[OeorditemID]=bodyCode;
	    }
	    else
	    {
	       orderArray[OeorditemID]=orderArray[OeorditemID]+","+bodyCode;
	     }
	}  	
	  	
	var orderBodyList="";
	for(var key in orderArray)
	{  
		//alert(key+"$"+orderArray[key]);
		var orderlist;
		if(orderArray[key]!="")
		{
			orderlist=key+"$"+orderArray[key];
		}
		else
		{
			orderlist=key;
		}
		if (orderBodyList=="")
		{
			orderBodyList=orderlist;
		}
		else
		{
			orderBodyList=orderBodyList+"@"+orderlist;
		}
		
	}
	
	return [arcItmDrList+"^"+orderBodyList+"^"+schDuleRowid,status,recLoc]
}


function addOneEquipment(modalityItems,modalityDr,modalityDesc)
{
	
	var arcItmFieldSet = Ext.getCmp(g_examItemFieldSetId);

	
	var colOfRow = 0;
	var row = 0;
	var dateListItems = [];
	var modiltyItemsInsert = [];
	//var modalityItems =[];
	var dateGroup ;
	
	var hasDesc = "N";
	
	for (var j = 0 ; j< dateStore.getCount();j++)
	{
		if ( colOfRow == colsOfResource)
		{
			//添加一行
			dateGroup = new Ext.form.CheckboxGroup({
				xtype: 'checkboxgroup',
		        //itemCls: 'x-check-group-alt',
		        fieldLabel: '',
		        allowBlank: true,
		        //id:'日期'+arcItmFieldSet.id++row,
		        anchor: '100%',
		        items: []
			});
		
			var dateListItemsInsert = dateListItems.slice((row*colsOfResource));
		
			dateGroup.items = dateListItemsInsert;
			arcItmFieldSet.add(dateGroup);
			arcItmFieldSet.doLayout();
			
			var modalityAddr=tkMakeServerCall("web.DHCRisResApptSchudleSystem","GetEqAddress",modalityDr);
				//设备变化新建设备组
	    var	modalityGroup = new Ext.form.CheckboxGroup({
					xtype: 'checkboxgroup',
		            //itemCls: 'x-check-group-alt',
		            //fieldLabel: ((hasDesc=="N")?(modalityDesc+":<br>"+modalityAddr):""),
		            fieldLabel: modalityDesc,
		            labelSeparator:'',
		            //width: 200,
		            //labelStyle:'width:200;',
		            allowBlank: true,
		            id:modalityDesc+"^"+arcItmFieldSet.title+"^"+arcItmFieldSet.id+"^"+row,
		            anchor: '100%',
		            items: []
			});
			hasDesc = "Y";
			var modalityItemsInsert = modalityItems.slice(row*colsOfResource);
			modalityGroup.items = modalityItemsInsert;
			
			arcItmFieldSet.add(modalityGroup);
			arcItmFieldSet.doLayout(); 
			dateGroup = "";
			row++;
			colOfRow = 0;
				
		}
		

		var combo = {
			width:155,
			items:[{
				xtype: 'label', 
				text : dateStore.getAt(j).get('dateDesc')+"("+dateStore.getAt(j).get('week')+")",
				cls:'x-form-check-group-label',
				anchor:'-15'
			}]
		};
		
		dateListItems[j]= combo;
	
		colOfRow++;
	}
	
	  //添加一行
			dateGroup = new Ext.form.CheckboxGroup({
				xtype: 'checkboxgroup',
		        //itemCls: 'x-check-group-alt',
		        fieldLabel: '',
		        allowBlank: true,
		        //id:'日期'+arcItmFieldSet.id+row,
		        anchor: '100%',
		        items: []
			});
		
			var dateListItemsInsert = dateListItems.slice((row*colsOfResource));
		
			dateGroup.items = dateListItemsInsert;
			arcItmFieldSet.add(dateGroup);
			arcItmFieldSet.doLayout();
			
			var modalityAddr=tkMakeServerCall("web.DHCRisResApptSchudleSystem","GetEqAddress",modalityDr);
				//设备变化新建设备组
	    var	modalityGroup = new Ext.form.CheckboxGroup({
					xtype: 'checkboxgroup',
		            //itemCls: 'x-check-group-alt',
		            //fieldLabel: ((hasDesc=="N")?(modalityDesc+":<br>"+modalityAddr):""),
		            fieldLabel: modalityDesc,
		            labelSeparator:'',
		            //width: 200,
		            //labelStyle:'width:200;',
		            allowBlank: true,
		            id:modalityDesc+"^"+arcItmFieldSet.title+"^"+arcItmFieldSet.id+"^"+row,
		            anchor: '100%',
		            items: []
			});
			
			var modalityItemsInsert = modalityItems.slice(row*colsOfResource);
			modalityGroup.items = modalityItemsInsert;
			
			arcItmFieldSet.add(modalityGroup);
			arcItmFieldSet.doLayout(); 
			
}





