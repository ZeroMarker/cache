// /名称: 组织类别Combo
// /描述: 组织类别Combo
// /编写者：zhangdongmei
// /编写日期: 2011.10.11
var DictUrl = "dhcst.";
var GroupId = session['LOGON.GROUPID'];
var gUserId=session['LOGON.USERID'];
var gLocId=session['LOGON.CTLOCID'];
/*
 * 授权科室ComboBox
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
 * 供应商分类ComboBox
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
 * 药房ComboBox
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
 * 科室ComboBox
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
 * 临床科室ComboBox
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
 * 供货厂商ComboBox
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
 * 生产厂商ComboBox
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
 * 招标配送商ComboBox
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
 * 科室组
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
 * 科室项目组
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
 * 发药窗口
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
 * 某科室下的人员
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
 * 科室管理组
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
 * 采购员ComboBox依据后台维护
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
 * 实盘窗口
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
 * 根据输入科室查找对应的CT_LocLinkLocation的科室ComboBox
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
 * 根据输入科室查找对应的发药人
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
 * 煎药状态ComboBox
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


//获取所有安全组
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
 * 产地ComboBox
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
 * 类组多选ComboBox  zhaoxinlong    
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
 * 请求单状态多选 yangshijie    
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
 * 请求单状态多选 yangshijie  去掉转移完成   
 */
var GetReqStatusNotTransCompStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url:"dhcst.orgutil.csp?actiontype=GetReqStatus&start=0&limit=999&StatusStr="+encodeURI("完成^部分转移^部分作废^全部作废")
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId', 'Code'])
});
