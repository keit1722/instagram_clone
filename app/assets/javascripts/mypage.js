//= require jquery3
//= require popper
//= require rails-ujs
//= require bootstrap-material-design/dist/js/bootstrap-material-design.js

// 画像のプレビュー機能
function previewFileWithId(selector) {
  const target = this.event.target;
  const file = target.files[0];
  const reader = new FileReader();
  reader.onloadend = function () {
    selector.src = reader.result;
  };
  if (file) {
    reader.readAsDataURL(file);
  } else {
    selector.src = "";
  }
}
