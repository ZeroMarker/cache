(function(obj) {

	var url = document.URL.toString();
	var Browser =(url ? ((url.split("&")[1])? url.split("&")[1].split("=")[1] :""):"");
	if (Browser==1) {
		$("#file-input").show();
		$("#file-input-button").hide();
	}else {
		$("#file-input").hide();
		$("#file-input-button").show();
	}
	var requestFileSystem = obj.webkitRequestFileSystem || obj.mozRequestFileSystem || obj.requestFileSystem;
	function onerror(message) {
		alert(message);
	}
	
	var model = (function() {
		var zipFileEntry, zipWriter, writer, creationMethod, URL = obj.webkitURL || obj.mozURL || obj.URL;

		return {
			setCreationMethod : function(method) {
				creationMethod = method;
			},		
			addFiles : function addFiles(files, oninit, onadd, onprogress, onend) {
				var addIndex = 0;
				function nextFile() {
					var file = files[addIndex];
					onadd(file);
					zipWriter.add(file.name, new zip.BlobReader(file), function() {
						addIndex++;
						if (addIndex < files.length)
							nextFile();
						else
							onend();
					}, onprogress);
				}

				function createZipWriter() {
					zip.createWriter(writer, function(writer) {
						zipWriter = writer;
						oninit();
						nextFile();
					}, onerror);
					$('#btnDownload').linkbutton('enable');
				}

				if (zipWriter)
					nextFile();
				else if (creationMethod == "Blob") {
					writer = new zip.BlobWriter();
					createZipWriter();
				}
			},
			getBlobURL : function(callback) {
				zipWriter.close(function(blob) {
					var blobURL = creationMethod == "Blob" ? URL.createObjectURL(blob) : zipFileEntry.toURL();
					callback(blobURL);
					zipWriter = null;
				});
			},
			getBlob : function(callback) {
				zipWriter.close(callback);
			}
		};
	})();

	(function() {
		var fileInput = document.getElementById("file-input");
		var fileInputButton = document.getElementById("file-input-button");
		var zipProgress = document.createElement("progress");
		var downloadButton = document.getElementById("btnDownload");
		var fileList = document.getElementById("file-list");
		
		if (Browser!=1) {
			var clickEvent;
			clickEvent = document.createEvent("MouseEvent");
			clickEvent.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
			fileInputButton.addEventListener("click", function () {
				return fileInput.dispatchEvent(clickEvent);
			}, false);
		}
		model.setCreationMethod("Blob");
		fileInput.addEventListener('change', function() {
			fileInput.disabled = true;
		   
			model.addFiles(fileInput.files, function() {
			}, function(file) {
				var li = document.createElement("li");
				zipProgress.value = 0;
				zipProgress.max = 0;
				li.textContent = file.name;
				li.appendChild(zipProgress);
				fileList.appendChild(li);
				
			}, function(current, total) {
				zipProgress.value = current;
				zipProgress.max = total;
				
			}, function() {
				if (zipProgress.parentNode)
					zipProgress.parentNode.removeChild(zipProgress);
				fileInput.value = "";
				fileInput.disabled = false;
				
			});
			
		}, false);
		
		downloadButton.addEventListener("click", function(event) {
			var target = event.target, entry;
			if (!downloadButton.download) {
				if (typeof navigator.msSaveBlob == "function") {
					model.getBlob(function(blob) {
						navigator.msSaveBlob(blob, "NIDP-"+new Date().getTime()*1000+ '.zip');
					});
					websys_showModal('close');  //关闭窗口
				} else {
					model.getBlobURL(function(blobURL) {
						var anchor = document.createElement("a");
						var clickEvent = new MouseEvent("click");
						anchor.href = blobURL;
						anchor.download = "NIDP-"+new Date().getTime()*1000+ '.zip';
						anchor.dispatchEvent(clickEvent);
						fileList.innerHTML = "";
					});
					event.preventDefault();
					websys_showModal('close');  //关闭窗口
					return false;
				}
			}			
		}, false);
	})();

})(this);