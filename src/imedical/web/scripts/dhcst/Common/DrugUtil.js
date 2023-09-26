// /����: ҩƷ�����ϢStore
// /����: ҩƷ�����ϢStore
// /��д�ߣ�zhangdongmei
// /��д����: 2012.05.07
var DictUrl = "dhcst.";
/*
 * ҽԺ
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
 * ��λ
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
 * �������ComboBox
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
 * ������ComboBox
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
 * ������ComboBox by grant ��Ȩ�������Ӧ�Ŀ����� add wyx 2014-04-28
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
 * ҩѧ����ComboBox
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
 * ҩѧ����ComboBox
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
 * ҩѧС��ComboBox
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
 * ����ͨ����ComboBox
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
 * ����ComboBox
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
 * �÷�ComboBox
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
 * Ƶ��ComboBox
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
 * �Ƴ�ComboBox
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
 * ҽ�����ComboBox
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
 * ��׼�ĺ�ComboBox
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
 * �������ComboBox
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
 * �б꼶��ComboBox
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
 * �������
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
 * ���Ʒ���ComboBox
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
 * ���ô���ComboBox
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
 * ��������ComboBox
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
 * ҽ������ComboBox
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
 * ҽ������ComboBox
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
 * ҽ�����ȼ�ComboBox
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
 * ��������ComboBox
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
 * �б�����ComboBox
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
 * �ʱ�����ComboBox
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
 * ���������ԭ��
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
 * ��λ��ComboBox
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
 * ���һ�λ��ComboBox
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
///���ҿ���ҩƷ��λ
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
 * �ӷ���ComboBox
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
 * ����ӷ���ComboBox
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
 * סԺ�ӷ���ComboBox
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
 * ������ҳ�ӷ���ComboBox
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
 * �����ӷ���ComboBox
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
 * �����ӷ���ComboBox
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
 * �²�����ҳComboBox
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
 * ����Ч��
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
 * ҽ������ڵĿ���
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
 * ��ҩ��עComboBox
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
 * ҩƷ��Һ����ComboBox
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
 * ��Σ���࣬��Σ-H,�����Σ-S,�൱��PHCDF_CriticalFlag�ķ���
 */
var HighRiskLevelStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['H', '��ͨ��Σ'], ['S', '�����Σ']]
});