var idx = lunr(function () {
  this.field('title')
  this.field('excerpt')
  this.field('categories')
  this.field('tags')
  this.ref('id')

  
  
    
    
  
    
    
  
    
    
      this.add({
          title: "Jodrell Bank Observatory",
          excerpt: "Jodrell Bank is awesome!\n\n\n\n\nFind out more at Wikipedia/Jodrell_Bank_Observatory\n",
          categories: ["science","astronomy"],
          tags: [],
          id: 0
      })
      
    
      this.add({
          title: "Stott Park Bobbin Mill",
          excerpt: "Stott Park Bobbin Mill is awesome!\n\n\n\n\n",
          categories: ["industry"],
          tags: [],
          id: 1
      })
      
    
      this.add({
          title: "Florence Nightingale Museum",
          excerpt: "The Florence Nightingale Museum is awesome!\n\n\n\n\n",
          categories: ["medicine"],
          tags: [],
          id: 2
      })
      
    
      this.add({
          title: "Bletchley Park",
          excerpt: "Bletchley Park is awesome!\n\n\n\n\n",
          categories: ["war"],
          tags: ["county:northamptonshire","country:gb"],
          id: 3
      })
      
    
      this.add({
          title: "Quarry Bank Mill",
          excerpt: "Quarry Bank Mill is awesome!\n\n\n\n\n",
          categories: ["war"],
          tags: [],
          id: 4
      })
      
    
      this.add({
          title: "National Museum of Computing",
          excerpt: "The National Museum of Computing is awesome!\n\n\n\n\n",
          categories: ["war","computing"],
          tags: [],
          id: 5
      })
      
    
      this.add({
          title: "Surgeon's Hall Museums",
          excerpt: "The Surgeon’s Hall Museum is awesome!\n\n\n\n\n",
          categories: ["science","biology"],
          tags: [],
          id: 6
      })
      
    
      this.add({
          title: "Twyford Waterworks",
          excerpt: "Twyford Waterworks is awesome!\n\n\n\n\n",
          categories: ["infrastructure"],
          tags: [],
          id: 7
      })
      
    
      this.add({
          title: "Museum of Science and Industry",
          excerpt: "The Museum of Science and Industry is awesome!\n\n\n\n\n",
          categories: ["science","industry"],
          tags: [],
          id: 8
      })
      
    
      this.add({
          title: "Kirkaldy Testing Museum",
          excerpt: "The Kirkaldy Testing Museum is awesome, but isn’t open very often!\n\n\n\n\n",
          categories: ["industry"],
          tags: [],
          id: 9
      })
      
    
      this.add({
          title: "Derwent Pencil Museum",
          excerpt: "The Derwent Pencil Museum is awesome, but was closed due to flooding when I was nearby!\n\n\n\n\n",
          categories: ["industry"],
          tags: [],
          id: 10
      })
      
    
  
    
    
  
});

console.log( jQuery.type(idx) );

var store = [
  
    
    
    
  
    
    
    
  
    
    
    
      
      {
        "title": "Jodrell Bank Observatory",
        "url": "https://www.nerdy-day-trips.com/posts/jodrell-bank/",
        "excerpt": "Jodrell Bank is awesome!\n\n\n\n\nFind out more at Wikipedia/Jodrell_Bank_Observatory\n",
        "teaser":
          
            null
          
      },
    
      
      {
        "title": "Stott Park Bobbin Mill",
        "url": "https://www.nerdy-day-trips.com/posts/stott-park-bobbin-mill/",
        "excerpt": "Stott Park Bobbin Mill is awesome!\n\n\n\n\n",
        "teaser":
          
            null
          
      },
    
      
      {
        "title": "Florence Nightingale Museum",
        "url": "https://www.nerdy-day-trips.com/posts/florence-nightingale-museum/",
        "excerpt": "The Florence Nightingale Museum is awesome!\n\n\n\n\n",
        "teaser":
          
            null
          
      },
    
      
      {
        "title": "Bletchley Park",
        "url": "https://www.nerdy-day-trips.com/posts/bletchley-park/",
        "excerpt": "Bletchley Park is awesome!\n\n\n\n\n",
        "teaser":
          
            null
          
      },
    
      
      {
        "title": "Quarry Bank Mill",
        "url": "https://www.nerdy-day-trips.com/posts/quarry-bank-mill/",
        "excerpt": "Quarry Bank Mill is awesome!\n\n\n\n\n",
        "teaser":
          
            null
          
      },
    
      
      {
        "title": "National Museum of Computing",
        "url": "https://www.nerdy-day-trips.com/posts/national-museum-of-computing/",
        "excerpt": "The National Museum of Computing is awesome!\n\n\n\n\n",
        "teaser":
          
            null
          
      },
    
      
      {
        "title": "Surgeon's Hall Museums",
        "url": "https://www.nerdy-day-trips.com/posts/surgeons-hall-museums/",
        "excerpt": "The Surgeon’s Hall Museum is awesome!\n\n\n\n\n",
        "teaser":
          
            null
          
      },
    
      
      {
        "title": "Twyford Waterworks",
        "url": "https://www.nerdy-day-trips.com/posts/twyford-waterworks/",
        "excerpt": "Twyford Waterworks is awesome!\n\n\n\n\n",
        "teaser":
          
            null
          
      },
    
      
      {
        "title": "Museum of Science and Industry",
        "url": "https://www.nerdy-day-trips.com/posts/museum-of-science-and-industry/",
        "excerpt": "The Museum of Science and Industry is awesome!\n\n\n\n\n",
        "teaser":
          
            null
          
      },
    
      
      {
        "title": "Kirkaldy Testing Museum",
        "url": "https://www.nerdy-day-trips.com/posts/kirkaldy-testing-museum/",
        "excerpt": "The Kirkaldy Testing Museum is awesome, but isn’t open very often!\n\n\n\n\n",
        "teaser":
          
            null
          
      },
    
      
      {
        "title": "Derwent Pencil Museum",
        "url": "https://www.nerdy-day-trips.com/posts/derwent-pencil-museum/",
        "excerpt": "The Derwent Pencil Museum is awesome, but was closed due to flooding when I was nearby!\n\n\n\n\n",
        "teaser":
          
            null
          
      },
    
  
    
    
    
  ]

$(document).ready(function() {
  $('input#search').on('keyup', function () {
    var resultdiv = $('#results');
    var query = $(this).val().toLowerCase().replace(":", "");
    var result =
      idx.query(function (q) {
        query.split(lunr.tokenizer.separator).forEach(function (term) {
          q.term(term, {  boost: 100 })
          if(query.lastIndexOf(" ") != query.length-1){
            q.term(term, {  usePipeline: false, wildcard: lunr.Query.wildcard.TRAILING, boost: 10 })
          }
          if (term != ""){
            q.term(term, {  usePipeline: false, editDistance: 1, boost: 1 })
          }
        })
      });
    resultdiv.empty();
    resultdiv.prepend('<p class="results__found">'+result.length+' Result(s) found</p>');
    for (var item in result) {
      var ref = result[item].ref;
      if(store[ref].teaser){
        var searchitem =
          '<div class="list__item">'+
            '<article class="archive__item" itemscope itemtype="http://schema.org/CreativeWork">'+
              '<h2 class="archive__item-title" itemprop="headline">'+
                '<a href="'+store[ref].url+'" rel="permalink">'+store[ref].title+'</a>'+
              '</h2>'+
              '<div class="archive__item-teaser">'+
                '<img src="'+store[ref].teaser+'" alt="">'+
              '</div>'+
              '<p class="archive__item-excerpt" itemprop="description">'+store[ref].excerpt+'</p>'+
            '</article>'+
          '</div>';
      }
      else{
    	  var searchitem =
          '<div class="list__item">'+
            '<article class="archive__item" itemscope itemtype="http://schema.org/CreativeWork">'+
              '<h2 class="archive__item-title" itemprop="headline">'+
                '<a href="'+store[ref].url+'" rel="permalink">'+store[ref].title+'</a>'+
              '</h2>'+
              '<p class="archive__item-excerpt" itemprop="description">'+store[ref].excerpt+'</p>'+
            '</article>'+
          '</div>';
      }
      resultdiv.append(searchitem);
    }
  });
});
