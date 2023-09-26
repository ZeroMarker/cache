//病种(症状)
var CanSelect = true;

$(function() {
    
    initDiseaseZTree();
    
    //引入按钮
    $('#btnRefDisease').live('click', function() {
        invoker.editorEvt.evtAfterGetMetaDataTree = function(commandJson) {
            var sectionKbNodes = '';
            $.each(commandJson.args.items, function (idx, item) {
                if ((item.Type == 'Section')&&(item.BindKBBaseID != '')) {
                    sectionKbNodes = sectionKbNodes + (sectionKbNodes == ''? '' : '^') + item.Code + ':' + item.BindKBBaseID;
                }
            });
            var data = ajaxDATA('String', 'EMRservice.BL.BLDiseases', 'GetBindFistNodeForOP', sectionKbNodes, invoker.patInfo.UserLocID, invoker.patInfo.DiseaseID, invoker.patInfo.EpisodeID);
            ajaxGET(data, function(ret) {
                if (ret != '') {
                    $.each(ret.split('^'), function(idx, item) {
                        invoker.iEmrPlugin.APPEND_COMPOSITE.call(invoker.iEmrPlugin, {
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
        invoker.iEmrPlugin.GET_METADATA_TREE();   
    });
    
});


$('#diseaseTree').tree({
    onSelect: function(node){
        invoker.patInfo.DiseaseID = node.id;
        DiseasePriview(node);
        CanSelect = false;
        setTimeout(function () {
                CanSelect = true;
            }, 1000);
    },
    onBeforeSelect: function(){
        return CanSelect;    
    }
});


function DiseasePriview (node){

    if (typeof node.state !=='undefined'){
        document.getElementById("diseaseText").innerHTML = "【请选择根节点】";
        return;
    }
    
    invoker.editorEvt.evtAfterGetMetaDataTree = function(commandJson) {
        var sectionKbNodes = '';
        $.each(commandJson.args.items, function (idx, item) {
            if ((item.Type == 'Section')&&(item.BindKBBaseID != '')) {
                sectionKbNodes = sectionKbNodes + (sectionKbNodes == ''? '' : '^') + item.Code + ':' + item.BindKBBaseID + ':' + item.DisplayName.replace('：','').replace(':','');
            }
        });

        var data = ajaxDATA('String', 'EMRservice.BL.BLDiseases', 'GetBindFistNodeForPreview', sectionKbNodes, invoker.patInfo.UserLocID, node.id, invoker.patInfo.EpisodeID);
        ajaxGETSync(data, function(ret) {
            if (ret != '') {    
                document.getElementById("diseaseText").innerHTML = ret;
            } else {
                document.getElementById("diseaseText").innerHTML = "【无知识库数据】";
                }
        }, function(err) {
            alert('error:' + err.message || err);
        });
    };
    invoker.iEmrPlugin.GET_METADATA_TREE(); 
    
}


// 对外接口
function initDiseaseZTree() {
    var data = ajaxDATA('String', 'EMRservice.BL.BLDiseases', 'GetDiseasesTree', invoker.patInfo.EpisodeID, invoker.patInfo.UserLocID);
    ajaxGET(data, function(ret) {
        if (ret != '') {
            $('#diseaseTree').tree({
                data: eval(ret)
            }).tree('expandAll');      
        }
     }, function(ret) {
         alert('GetDiseaseZTreeData error:' + ret);
     });
}


