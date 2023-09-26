// /名称: 药品相关信息Store
// /描述: 药品相关信息Store
// /编写者：zhangdongmei
// /编写日期: 2012.05.07
var DictUrl = "dhcst.";
/*
 * 医院
 */
var HospStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=Hosp&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 单位
 */
var CTUomStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=CTUom&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId']),
			baseParams:{CTUomDesc:''}				
					
		});

var CONUomStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=CONUom&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId']),
			baseParams:{UomId:''}
		});

var ItmUomStore = new Ext.data.Store({
	        
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=INCIUom&ItmRowid='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 库存类组ComboBox
 */
var IncScStkGrpStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.drugutil.csp?actiontype=INCSCStkGrp&StkType=G&start=0&limit=200'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

/*
 * 库存分类ComboBox
 */
var StkCatStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
				url :'dhcst.drugutil.csp?actiontype=StkCat'
			}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});
/*
 * 库存分类ComboBox by grant 授权的类组对应的库存分类 add wyx 2014-04-28
 */
var StkCatStoreByGrant = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
				url :'dhcst.drugutil.csp?actiontype=StkCatByGrant'
			}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});
/*
 * 药学大类ComboBox
 */
var PhcCatStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
				url : 'dhcst.drugutil.csp?actiontype=PhcCat&start=0&limit=999'
			}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PhccDesc:''}
});

/*
 * 药学子类ComboBox
 */
var PhcSubCatStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.drugutil.csp?actiontype=PhcSubCat&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PhcCatId:''}
});


/*
 * 药学小类ComboBox
 */
var PhcMinCatStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.drugutil.csp?actiontype=PhcMinCat&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PhcSubCatId:''}
});

/*
 * 处方通用名ComboBox
 */
var PhcGenericStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.drugutil.csp?actiontype=PhcGeneric&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PhcGeName:''}
});


/*
 * 剂型ComboBox
 */
var PhcFormStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.drugutil.csp?actiontype=PhcForm&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PHCFDesc:''}
});

/*
 * 用法ComboBox
 */
var PhcInStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.drugutil.csp?actiontype=PHCInstruc&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PHCInDesc:''}
});

/*
 * 频次ComboBox
 */
var PhcFreqStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.drugutil.csp?actiontype=PHCFreq&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PhcFrDesc:''}
});

/*
 * 疗程ComboBox
 */
var PhcDurationStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.drugutil.csp?actiontype=PhcDuration&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PhcDuDesc:''}
});

/*
 * 医保类别ComboBox
 */
var OfficeCodeStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=GetInsuCat'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});


/*
 * 批准文号ComboBox
 */
var INFORemarkStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=OfficeCode&Type=Gp'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 处方类别ComboBox
 */
var INFOOTCStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=OfficeCode&Type=Gpp'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 招标级别ComboBox
 */
var INFOPBLevelStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=GetPBLevel'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 质量层次
 */
var INFOQualityLevelStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=GetQualityLevel'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 管制分类ComboBox
 */
var PhcPoisonStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=PhcPoison'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});


/*
 * 费用大类ComboBox
 */
var ArcBillGrpStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=ArcBillGrp'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 费用子类ComboBox
 */
var ArcBillSubStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=ArcBillSub'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId']),
			baseParams:{ARCBGRowId:""}
		});

/*
 * 医嘱大类ComboBox
 */
var OrderCategoryStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=OrderCategory&StkType='+App_StkTypeCode
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * 医嘱子类ComboBox
 */
var ArcItemCatStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=ArcItemCat&StkType='+App_StkTypeCode
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
			//queryMode:'local',
			//autoLoad:'false'
		});

/*
 * 医嘱优先级ComboBox
 */
var OECPriorityStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=OECPriority'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 定价类型ComboBox
 */
var MarkTypeStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=MarkType'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
/*
 * 招标名称ComboBox
 */
var PublicBiddingListStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=PublicBiddingList'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 帐薄分类ComboBox
 */
var BookCatStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=BookCat'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 库存项屏蔽原因
 */
var ItmNotUseReasonStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=GetItmNotUseReason'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * 货位码ComboBox
 */
var StkBinStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.drugutil.csp?actiontype=GetStkBin&Desc=&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

/*
 * 科室货位码ComboBox
 */
var LocStkBinStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.drugutil.csp?actiontype=GetLocStkBin'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{LocId:'',Desc:''}
});

///LocStkBinQStore
///查找科室药品货位
var LocStkBinQStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.drugutil.csp?actiontype=GetLocStkBinQ'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{ItmRowid:'',LocId:'',Desc:''}
});

/*
 * 子分类ComboBox
 */
var TarSubCateStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=GetTarSubCate&Desc='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 会计子分类ComboBox
 */
var TarAcctCateStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=GetTarAcctCate&Desc='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * 住院子分类ComboBox
 */
var TarInpatCateStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=GetTarInpatCate&Desc='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * 病历首页子分类ComboBox
 */
var TarMRCateStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=GetTarMRCate&Desc='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * 核算子分类ComboBox
 */
var TarEMCCateStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=GetTarEMCCate&Desc='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 门诊子分类ComboBox
 */
var TarOutpatCateStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=GetTarOutpatCate&Desc='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});


/*
 * 新病案首页ComboBox
 */
var TarNewMRCateStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcst.drugutil.csp?actiontype=GetTarNewMRCate&Desc='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
/*
 * 批号效期
 */
var BatExDateStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.drugutil.csp?actiontype=BatExDate'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{ItmRowid:'',LocId:'',Desc:''}
});


/*
 * 医嘱项存在的科室
 */
var dispuomStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
				url : 'dhcst.drugutil.csp?actiontype=GetInciLoc'
			}),
		reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
		baseParams:{Arcitm:''}
	});
/*
 * 草药备注ComboBox
 */
var PhcSpecIncStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.drugutil.csp?actiontype=PHCSpecInc&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PHCSpecInDesc:''}
});
/*
 * WhoDDDComboBox
 */
var PHCDFWhoDDDUomStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.drugutil.csp?actiontype=PHCDFWhoDDDUom&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PHCDFWhoDDD:'',PHCDFCode:''}
});
/*
 * 药品配液分类ComboBox
 */
var PHCPivaCatStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
				url :'dhcst.drugutil.csp?actiontype=GetPHCPivaCat&Desc='
			}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});
/*
 * 高危分类，高危-H,特殊高危-S,相当于PHCDF_CriticalFlag的分类
 */
var HighRiskLevelStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['H', '普通高危'], ['S', '特殊高危']]
});