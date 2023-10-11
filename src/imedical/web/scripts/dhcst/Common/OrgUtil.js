// /����: ��֯���Combo
// /����: ��֯���Combo
// /��д�ߣ�zhangdongmei
// /��д����: 2011.10.11
var DictUrl = "dhcst.";
var GroupId = session['LOGON.GROUPID'];
var gUserId=session['LOGON.USERID'];
var gLocId=session['LOGON.CTLOCID'];
/*
 * ��Ȩ����ComboBox
 */
var GetGroupDeptStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url:'dhcst.orgutil.csp?actiontype=GetGroupDept&start=0&limit=999&groupId='+GroupId+'&locDesc='
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId', 'Code'])
});


/*
 * ��Ӧ�̷���ComboBox
 */
var GetVendorCatStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url:'dhcst.orgutil.csp?actiontype=GetVendorCat&start=0&limit=100'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});



/*
 * ҩ��ComboBox
 */
var PhaDeptStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : DictUrl
				+ 'orgutil.csp?actiontype=PhaDept&start=0&limit=100'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});


/*
 * ����ComboBox
 */
var DeptLocStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : DictUrl
				+ 'orgutil.csp?actiontype=DeptLoc&start=0&limit=200'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

/*
 * �ٴ�����ComboBox
 */
var ClinicDeptStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : DictUrl
				+ 'orgutil.csp?actiontype=ClinicDept&start=0&limit=200'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

/*
 * ��������ComboBox
 */
var APCVendorStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.orgutil.csp?actiontype=APCVendor'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

/*
 * ��������ComboBox
 */
var PhManufacturerStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.orgutil.csp?actiontype=PhManufacturer'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});


/*
 * �б�������ComboBox
 */
var CarrierStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.orgutil.csp?actiontype=Carrier&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId']),
			baseParams:{CADesc:''}
		});
		
/*
 * ������
 */
var StkLocGrpStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.orgutil.csp?actiontype=StkLocGrp&str=&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
		
/*
 * ������Ŀ��
 */
var StkItemGrpStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.orgutil.csp?actiontype=StkItemGrp&str=&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * ��ҩ����
 */
var PhaWindowStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.orgutil.csp?actiontype=GetPhaWindow&LocId=&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * ĳ�����µ���Ա
 */
var DeptUserStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.orgutil.csp?actiontype=GetDeptUser&locId=&Desc=&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * ���ҹ�����
 */
var LocManGrpStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.orgutil.csp?actiontype=GetLocManGrp&start=0&limit=999&UserId='+gUserId
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * �ɹ�ԱComboBox���ݺ�̨ά��
*/
var PurchaseUserStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : DictUrl
								+ 'orgutil.csp?actiontype=LocPPLUser&start=0&limit=999'
					}),
			baseParams:{'locId':gLocId},
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId', 'Default'])
		});

/*
 * ʵ�̴���
 */
var INStkTkWindowStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : DictUrl+'orgutil.csp?actiontype=GetInStkTkWindow&LocId=&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
/*
 * ����������Ҳ��Ҷ�Ӧ��CT_LocLinkLocation�Ŀ���ComboBox
 */
var DocLocStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : DictUrl+'orgutil.csp?actiontype=GetDocLoc&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{FroLoc:''}
});
/*
 * ����������Ҳ��Ҷ�Ӧ�ķ�ҩ��
 */
var LocDispUserStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : DictUrl+'orgutil.csp?actiontype=GetLocUser&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{FroLoc:''}
});

/*
 * ��ҩ״̬ComboBox
 */
var GetMBCStateStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url:'dhcst.orgutil.csp?actiontype=GetMBCState&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId', 'Code'])
});


//��ȡ���а�ȫ��
var GroupComboStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : DictUrl
				+ 'orgutil.csp?actiontype=GetGroup&start=0&limit=20'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

/*
 * ����ComboBox
 */
var OriginStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.orgutil.csp?actiontype=Origin'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

/* 
 * �����ѡComboBox  zhaoxinlong    
 */
var GetGrpCatStkStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url:'dhcst.orgutil.csp?actiontype=GetGrpCatStk&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId', 'Code'])
});


/* 
 * ����״̬��ѡ yangshijie    
 */
var GetReqStatusStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url:'dhcst.orgutil.csp?actiontype=GetReqStatus&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId', 'Code'])
});

/* 
 * ����״̬��ѡ yangshijie  ȥ��ת�����   
 */
var GetReqStatusNotTransCompStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url:"dhcst.orgutil.csp?actiontype=GetReqStatus&start=0&limit=999&StatusStr="+encodeURI("���^����ת��^��������^ȫ������")
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId', 'Code'])
});
