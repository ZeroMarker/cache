//病种
var disease = {};

$(function() {

    var diseaseCombo = $('#disease');
    var diseaseTree = $('#diseasetree');

    //定义一个全局变量，用来存储ZTree从后台获取的病种数据
    var diseaseTreeNodesAll = "";
    var ParentNodesIDs = "";

    //引入按钮
    $('#btnRefDisease').live('click', function() {
        editorEvt.evtAfterGetMetaDataTree = function(commandJson) {
            var sectionKbNodes = '';
            $.each(commandJson.args.items, function (idx, item) {
                if ((item.Type == 'Section')&&(item.BindKBBaseID != '')) {
                    sectionKbNodes = sectionKbNodes + (sectionKbNodes == ''? '' : '^') + item.Code + ':' + item.BindKBBaseID;
                }
            });
            var data = ajaxDATA('String', 'EMRservice.BL.BLDiseases', 'GetBindFistNodeForOP', sectionKbNodes, patInfo.UserLocID, patInfo.DiseaseID, patInfo.EpisodeID);
            ajaxGET(data, function(ret) {
                if (ret != '') {
                    $.each(ret.split('^'), function(idx, item) {
                        iEmrPlugin.APPEND_COMPOSITE.call(iEmrPlugin, {
                            SectionCode: item.split(':')[0],
                            KBNodeID: item.split(':')[1],
                            isSync: true
                        });
                    });
                }
            }, function(err) {
                alert('error:' + err.message || err);
            });
        };
        iEmrPlugin.GET_METADATA_TREE();   
    });

    var comboHeight = $('#res_region').layout('panel','center').panel('options').height;
    //Desc:初始化病种下拉框
    diseaseCombo.combo({
        width: 160,
        height: 23,
        panelWidth: 300,
        panelHeight: comboHeight,
        editable: false
    });

    $('#combopanel').appendTo(diseaseCombo.combo('panel'));

    //光标定位到 病种文本框内 自动展开下拉树 add by niucaicai 2016-4-15
    diseaseCombo.combo("textbox").click(function() {
        diseaseCombo.combo("showPanel");
        var comboHeight = $('#res_region').layout('panel','center').panel('options').height;
        diseaseCombo.combo("panel").panel('resize',{height:comboHeight});
        var treeObj = $.fn.zTree.getZTreeObj("diseasetree");
        if (treeObj != null) treeObj.expandAll(true);
    });

    //筛选按钮
    $('#btnSearchDisease').live('click', function() {
        //筛选
        function diseaseSearch() {
            ParentNodesIDs = "";
            var treeObj = $.fn.zTree.getZTreeObj("diseasetree");
            if (treeObj === null) return;

            //搜索前删除掉目前展现的所有节点，然后加载全部节点数据，保证搜索时是在全部数据上做的检索
            var allNodes = treeObj.getNodes();
            for (i = 0; i < allNodes.length;) {
                treeObj.removeNode(allNodes[i]);
            }
            treeObj.addNodes(null, diseaseTreeNodesAll);

            var diseaseCodeValue = $('#diseaseCode').val();
            var diseaseCodeDesc = $('#diseaseDesc').val();
            if (diseaseCodeValue == "" && diseaseCodeDesc == "") {
                return treeObj.expandAll(true); //如果代码和描述同时为空，则显示全部数据
            }
            //获取筛选出来的节点
            var getedNodes = treeObj.getNodesByFilter(filter); // 查找节点集合

            //搜索动作完成后，删除掉目前展现的所有节点，只展现搜索结果
            var allNodesTwo = treeObj.getNodes();
            for (i = 0; i < allNodesTwo.length;) {
                treeObj.removeNode(allNodesTwo[i]);
            }
            treeObj.addNodes(null, getedNodes);
            treeObj.expandAll(true);
        }

        //根据检索条件，得到符合条件的节点
        function filter(node) {
            var diseaseCodeValue = $('#diseaseCode').val();
            var diseaseCodeDesc = $('#diseaseDesc').val();
            //return (node.id.indexOf(diseaseCodeValue)>-1 && node.name.indexOf(diseaseCodeDesc)>-1);

            if (node.id.indexOf(diseaseCodeValue) > -1 && node.name.indexOf(diseaseCodeDesc) > -1 && node.id !== "0") {
                var ret = true;
                //如果当前节点为符合条件的父节点，保留
                if (node.isParent) {
                    if (ParentNodesIDs == "") {
                        ParentNodesIDs = node.id;
                    } else {
                        ParentNodesIDs = ParentNodesIDs + "^" + node.id;
                    }
                } else {
                    //如果当前节点为符合条件的叶子节点，判断其父节点是否已保留，若父节点已保留则该子节点不保留，若父节点没有保留，则该叶子节点保留
                    var ParentNode = node.getParentNode();
                    //有可能病种维护时，没有分组目录，只有具体病种，此情况下获取到的父节点为null，不去做判断
                    if (ParentNode !== null) {
                        var ParentNodesIDsLength = ParentNodesIDs.split("^").length;
                        for (i = 0; i < ParentNodesIDsLength; i++) {
                            if (ParentNode.id == ParentNodesIDs.split("^")[i]) {
                                ret = false;
                            }
                        }
                    }
                }
                return ret;
            }
        }
        diseaseSearch();
    });

    //ztree显示、回调函数、数据格式配置
    var ztSetting = {
        treeId: "diseasetree",
        view: {
            showIcon: true,
            fontCss: {"font-family":"微软雅黑"}
        },
        callback: {
            beforeClick: function(treeId, treeNode, clickFlag) {
                //如果返回 false，zTree 将不会选中节点，也无法触发 onClick 事件回调函数
                //当是父节点 返回false 不让选取
                return !treeNode.isParent;
            },
            onClick: function(event, treeId, treeNode) {
                //ztree鼠标左键点击回调函数
                diseaseCombo.combo('setValue', treeNode.attributes.rowID);
                diseaseCombo.combo('setText', treeNode.name);
                diseaseCombo.combo("hidePanel");
                patInfo.DiseaseID = treeNode.attributes.rowID;
            },
            onNodeCreated: function(event, treeId, treeNode) {
                //节点被创建之后，去判断该节点是否是病历已绑定的病种，是:下拉框选中显示该节点;否:继续下一个节点判断
                if (treeNode.attributes.type == "root" && treeNode.attributes.isUsed == "1") {
                    diseaseCombo.combo('setValue', treeNode.attributes.rowID);
                    diseaseCombo.combo('setText', treeNode.name);
                    patInfo.DiseaseID = treeNode.attributes.rowID;
                } else if (treeNode.attributes.type == "disease" && treeNode.attributes.isUsed == "1") {
                    diseaseCombo.combo('setValue', treeNode.attributes.rowID);
                    diseaseCombo.combo('setText', treeNode.name);
                    patInfo.DiseaseID = treeNode.attributes.rowID;
                } else {
                    //选中关联诊断病种
                    var fnSetTree = function(treeNode) {
                        var node = treeNode;
                        if (node.isParent) {
                            var children = node.children;
                            for (var j = 0; j < children.length; j++) {
                                if (children[j].attributes.type == "disease" && children[j].attributes.isUsed == "1") {
                                    diseaseCombo.combo('setValue', children[j].attributes.rowID);
                                    diseaseCombo.combo('setText', children[j].name);
                                    patInfo.DiseaseID = children[j].attributes.rowID;
                                    return;
                                }
                                fnSetTree(children[j]);
                            }
                        }
                    }

                    fnSetTree(treeNode);
                }
            }
        },
        data: {
            simpleData: {
                enable: false
            }
        }
    };

    // 对外接口
    disease.initDiseaseZTree = function() {
        var data = ajaxDATA('String', 'EMRservice.BL.BLDiseases', 'GetDiseasesList', patInfo.EpisodeID, patInfo.UserLocID);
        ajaxGET(data, function(ret) {
            if (ret != '') {
                //改变全局变量的值，用来存储ZTree从后台获取的病种数据
                diseaseTreeNodesAll = $.parseJSON(ret);
                $('#diseasetree').attr("class", "ztree chats_ztree");
                $.fn.zTree.init($('#diseasetree'), ztSetting, diseaseTreeNodesAll);
            }
        }, function(ret) {
            alert('GetDiseaseZTreeData error:' + ret);
        });
    }

});
