let comics = [];

// LOAD DATABASE
fetch("data/comics.json")
  .then(res => res.json())
  .then(data => {
    comics = data;

    renderTrending();
    renderFeatured();
  });

/* -----------------------------
   TRENDING SECTION
------------------------------*/
function renderTrending(){
  const container = document.getElementById("trendingGrid");
  if(!container) return;

  container.innerHTML = "";

  // first 4 comics = trending (simple logic)
  comics.slice(0,4).forEach(c => {
    container.innerHTML += cardHTML(c);
  });
}

/* -----------------------------
   FEATURED SECTION
------------------------------*/
function renderFeatured(){
  const container = document.getElementById("featuredGrid");
  if(!container) return;

  container.innerHTML = "";

  // last comics = featured
  comics.slice(-3).forEach(c => {
    container.innerHTML += cardHTML(c);
  });
}

/* -----------------------------
   CARD TEMPLATE
------------------------------*/
function cardHTML(c){
  return `
    <div class="card" onclick="openComic('${c.folder}')">
      <img src="${c.cover}">
      <div class="info">
        <b>${c.title}</b>
        <div>${c.genre} | ${c.chapters} CH</div>
      </div>
    </div>
  `;
}

/* -----------------------------
   OPEN COMIC
------------------------------*/
function openComic(folder){
  window.location.href = "reader.html?comic=" + folder;
}
