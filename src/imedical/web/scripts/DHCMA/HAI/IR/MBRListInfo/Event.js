//页面Event
function InitMBRListInfoEvent(obj){
   
    obj.LoadEvent = function(args){
		//初始查询结果
		obj.refreshOprQry(); 
        $('#btnEdit').on('click', function(){
			var rd=obj.gridMBRInfo.getSelected();
            obj.btnAction_Click(rd);
		});
	}
    obj.grid_onSelect = function (){
		var rowData = obj.gridMBRInfo.getSelected();

		if (rowData["MrNo"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnEdit").linkbutton("disable");
			obj.gridMBRInfo.clearSelections();
		} else {
			obj.RecRowID = rowData["MrNo"];
			$("#btnEdit").linkbutton("enable");
			
		}
	}
    
     //检索框
     $('#searchbox').searchbox({
        searcher: function (value, name) {
            if(value=="") {
                obj.refreshOprQry();
            } else {
                searchText($("#gridMBRInfo"), value,1);
            }           
        }
    });
     //刷新列表
     obj.refreshOprQry = function () {
       // $("#gridOEItemList").datagrid("loading");
        var Ret = $cm({
            ClassName: "DHCHAI.IRS.CtlMRBSrv",
		    QueryName: "QryMRBByEpsodeDr",
		    aEpisodeDr:EpisodeDr,
            page: 1,
            rows: 99999
       }, function (rs) {
           $('#gridMBRInfo').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
       });
     }
     obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: '处置隔离编辑',
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'下隔离医嘱',
				handler:function(){
					obj.btnSave_click();
				}
			},{
				text:'取消',
				handler:function(){
					$HUI.dialog('#layer').close();
				}
			}]
		});
	}
    obj.btnSave_click= function(){
        var MRBShieldDesc = $('#cboMRBIsoOEOrd').combobox('getText');
        if (MRBShieldDesc==""){
            $.messager.popover({
                msg: '请选择隔离医嘱!',
                type: 'info',
                timeout: 2000, 		//0不自动关闭。3000s
                showType: 'slide'  //show,fade,slide
            });
            return false;
        }
        // 调用接口下隔离医嘱
        var ret = $m({
            ClassName: "DHCHAI.DP.OEItmMast",
            MethodName: "SaveOrderItem",
            aEpisodeDr:EpisodeDr,
            aMRBShieldDesc:MRBShieldDesc,
            aUserID:session['LOGON.USERID'],
            aLocID:session['LOGON.CTLOCID'],
        }, false);
        if(parseInt(ret)>0){
            // Exec 方法功能处理消息
            if(DetailsId!=""){
                var ret = $m({
                    ClassName: "websys.DHCMessageInterface",
                    MethodName: "ExecAll",
                    ToUserId:DetailsId
                }, false);
                //var ret = $.Tool.RunServerMethod('websys.DHCMessageInterface','Exec',"","1079",Paadm,"","ResultID="+ResultID,session['LOGON.USERID']);
            }
            $.messager.popover({
                msg: '处置成功,已下隔离医嘱!',
                type: 'success',
                timeout: 2000, 		//0不自动关闭。3000s
                showType: 'slide'  //show,fade,slide
            });
            $HUI.dialog('#layer').close();
            obj.refreshOprQry();					
        }else{
            $.messager.popover({
                msg: '处置失败!',
                type: 'error',
                timeout: 2000, 		//0不自动关闭。3000s
                showType: 'slide'  //show,fade,slide
            });
            return false;
        }
					
    }
    obj.btnAction_Click = function(rd)
	{
		var MRBActFlag=rd["MRBActFlag"];
		if (MRBActFlag==""){   // 未做隔离处理
			
			//获取唯一隔离医嘱
            var ISOOEOrdDesc = $m({
                ClassName: "DHCHAI.IRS.CtlMRBSrv",
                MethodName: "GetISOOEOrd",
            }, false);
			if(ISOOEOrdDesc==""){ // 隔离医嘱不唯一
				// 如果多耐分类未维护隔离医嘱,给出提示,不能下医嘱
				var MRBID = rd["MRBID"];
				// 初始化快捷消息信息
                var DataQuery = $cm({
                    ClassName: "DHCHAI.IRS.CRuleMRBSrv",
                    QueryName: "QryMRBOEOrdByMRBID",
                    aMRBID:MRBID,
                }, false);
                
				if(DataQuery){
					var len = DataQuery.total;
					if (len<1){
                        $.messager.popover({
                            msg: '多耐分类未维护隔离医嘱，请先维护隔离医嘱!',
                            type: 'error',
                            timeout: 2000, 		//0不自动关闭。3000s
                            showType: 'slide'  //show,fade,slide
                        });
						return false;
					} else if (len ==1){
                        var firstObj=DataQuery.rows[0];
                        var MRBShieldDesc = firstObj.BTOrdDesc;
                        // 调用接口下隔离医嘱
                        var ret = $m({
                            ClassName: "DHCHAI.DP.OEItmMast",
                            MethodName: "SaveOrderItem",
                            aEpisodeDr:EpisodeDr,
                            aMRBShieldDesc:MRBShieldDesc,
                            aUserID:session['LOGON.USERID'],
                            aLocID:session['LOGON.CTLOCID'],
                        }, false);
                        if(parseInt(ret)>0){
                            // Exec 方法功能处理消息
                            if(DetailsId!=""){
                                var ret = $m({
                                    ClassName: "websys.DHCMessageInterface",
                                    MethodName: "ExecAll",
                                    ToUserId:DetailsId
                                }, false);
                                //var ret = $.Tool.RunServerMethod('websys.DHCMessageInterface','Exec',"","1079",Paadm,"","ResultID="+ResultID,session['LOGON.USERID']);
                            }
                            $.messager.popover({
                                msg: '处置成功,已下隔离医嘱!',
                                type: 'success',
                                timeout: 2000, 		//0不自动关闭。3000s
                                showType: 'slide'  //show,fade,slide
                            });
                            obj.refreshOprQry();					
                        }else{
                            $.messager.popover({
                                msg: '下隔离医嘱失败',
                                type: 'error',
                                timeout: 2000, 		//0不自动关闭。3000s
                                showType: 'slide'  //show,fade,slide
                            });
                            return false;
                        }
                    } else{
                        $('#layer').show();
			            obj.SetDiaglog(rd);
                    }
				}else{
					$.messager.popover({
                        msg: '多耐分类未维护隔离医嘱，请先维护隔离医嘱!',
                        type: 'error',
                        timeout: 2000, 		//0不自动关闭。3000s
                        showType: 'slide'  //show,fade,slide
                    });
					return false;
				}
                
				

			}else{
				var MRBShieldDesc = ISOOEOrdDesc;
			  	// 调用接口下隔离医嘱
                var ret = $m({
                    ClassName: "DHCHAI.DP.OEItmMast",
                    MethodName: "SaveOrderItem",
                    aEpisodeDr:EpisodeDr,
                    aMRBShieldDesc:MRBShieldDesc,
                    aUserID:session['LOGON.USERID'],
                    aLocID:session['LOGON.CTLOCID'],
                }, false);
                if(parseInt(ret)>0){
					// Exec 方法功能处理消息
					if(DetailsId!=""){
                        var ret = $m({
                            ClassName: "websys.DHCMessageInterface",
                            MethodName: "ExecAll",
                            ToUserId:DetailsId
                        }, false);
						//var ret = $.Tool.RunServerMethod('websys.DHCMessageInterface','Exec',"","1079",Paadm,"","ResultID="+ResultID,session['LOGON.USERID']);
					}
                    $.messager.popover({
                        msg: '处置成功,已下隔离医嘱!',
                        type: 'success',
                        timeout: 2000, 		//0不自动关闭。3000s
                        showType: 'slide'  //show,fade,slide
                    });
                    obj.refreshOprQry();					
				}else{
					$.messager.popover({
                        msg: '下隔离医嘱失败',
                        type: 'error',
                        timeout: 2000, 		//0不自动关闭。3000s
                        showType: 'slide'  //show,fade,slide
                    });
					return false;
				}
			} 
		}else{
			// Exec 方法功能处理消息
			if(DetailsId!=""){
                var ret = $m({
                    ClassName: "websys.DHCMessageInterface",
                    MethodName: "ExecAll",
                    ToUserId:DetailsId
                }, false);
			}
            $.messager.popover({
				msg: '该条记录已做隔离处理!',
				type: 'success',
				timeout: 2000, 		//0不自动关闭。3000s
				showType: 'slide'  //show,fade,slide
			});
		}
	};
}