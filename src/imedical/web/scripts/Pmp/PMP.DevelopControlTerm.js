//����ƽ  
//2015-03-16

//��ȡ��Ʒ�������б�����
    var SelectProduct=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=Product'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	}); 
//��ȡ�������������б�����
    var AddDetailType=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=AddDetailType'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	}); 
  //��ȡ�����б�
   var DevDetailStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=DevDetailStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['Rowid','DevName','DevStatus','DevAppraisal','DevTel','DevEmail','DevProduct','DevInDate','DevInTime','DevOutDate','DevOutTime','DevBusine'])
    	});
   //��ȡ����������Ϣ�б�
  var DetailStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=DetailStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['DevRowiddetail','DevRowid','DevNamedetail','DevTeldetail','DevProductdetail','DevUpDatedetail','DevUpTimedetail','DevUpUserdetail','DevUpTypedetail','DevMenudetail'])
    	});
   //��ȡ������б�
   var ImListStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=ImListStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['ImRowid','ImName','ImStatus','ImCreatDate','ImCreatUser','ImCreateLoc','ImCreateTel','ImMenu','ImSituation','ImStandby3','ImEmergency','ImCode','ImType','ImDegree'])
    	});
   //��ȡδ����б�
   var ImListNStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=ImListNStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['ImNRowid','ImNName','ImNStatus','ImNCreatDate','ImNCreatUser','ImNCreateLoc','ImNCreateTel','ImNMenu','ImNSituation','ImNStandby3','ImNEmergency','ImNCode','ImNType','ImNDegree'])
    	});
    	
   //��ȡ�����б�
   var DetailAppraisalStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=DetailAppraisalStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['AppraisalRowid','AppraisalName','AppraisalType','AppraisalSum','AppraisalAttendance','AppraisalWorkEff','AppraisalWorkAtt','AppraisalOtherStais','AppraisalMenu','AppraisalBY5','AppraisalUser','AppraisalDate'])
    	});
   //��ȡ������Ϣ
   var AdjunctFlagStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=AdjunctFlagStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['AdjunctFlagRowid','AdjunctFlagName','AdjunctFlagTime','AdjunctFlagUser','AdjunctFlagType'])
    	});