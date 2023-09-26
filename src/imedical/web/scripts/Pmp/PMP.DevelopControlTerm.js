//张枕平  
//2015-03-16

//获取产品组下拉列表数据
    var SelectProduct=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=Product'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	}); 
//获取开发类型下拉列表数据
    var AddDetailType=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=AddDetailType'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	}); 
  //获取开发列表
   var DevDetailStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=DevDetailStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['Rowid','DevName','DevStatus','DevAppraisal','DevTel','DevEmail','DevProduct','DevInDate','DevInTime','DevOutDate','DevOutTime','DevBusine'])
    	});
   //获取开发附件信息列表
  var DetailStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=DetailStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['DevRowiddetail','DevRowid','DevNamedetail','DevTeldetail','DevProductdetail','DevUpDatedetail','DevUpTimedetail','DevUpUserdetail','DevUpTypedetail','DevMenudetail'])
    	});
   //获取已完成列表
   var ImListStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=ImListStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['ImRowid','ImName','ImStatus','ImCreatDate','ImCreatUser','ImCreateLoc','ImCreateTel','ImMenu','ImSituation','ImStandby3','ImEmergency','ImCode','ImType','ImDegree'])
    	});
   //获取未完成列表
   var ImListNStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=ImListNStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['ImNRowid','ImNName','ImNStatus','ImNCreatDate','ImNCreatUser','ImNCreateLoc','ImNCreateTel','ImNMenu','ImNSituation','ImNStandby3','ImNEmergency','ImNCode','ImNType','ImNDegree'])
    	});
    	
   //获取评价列表
   var DetailAppraisalStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=DetailAppraisalStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['AppraisalRowid','AppraisalName','AppraisalType','AppraisalSum','AppraisalAttendance','AppraisalWorkEff','AppraisalWorkAtt','AppraisalOtherStais','AppraisalMenu','AppraisalBY5','AppraisalUser','AppraisalDate'])
    	});
   //获取附件信息
   var AdjunctFlagStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=AdjunctFlagStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['AdjunctFlagRowid','AdjunctFlagName','AdjunctFlagTime','AdjunctFlagUser','AdjunctFlagType'])
    	});