<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Skaylink BR Weekly | Docker</title>
  <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" />
</head>
<body>
  <?php
    $port = getenv("BACKEND_PORT");
    echo $port;
    $address = getenv("BACKEND_ADDRESS") . ":" .$port . "/people";
    echo $address;
    #$address = "20.31.81.254" + ":" + "9001" + "/people";
    #$result = file_get_contents($address);
    $result = file_get_contents($address);
    $people = json_decode($result);
  ?>
  
  <div class="container">
    <table class="table table-bodered table-hover">
      <thead class="thead-light">
        <tr>
          <th class="text-center" colspan="4">SKAYLINK BR TEAM</th>
        </tr>
        </thead>
        <thead class="thead-dark">
        <tr>
          <th>Name</th>
          <th>Email</th>
          <th>Title</th>
          <th>Location</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach($people as $person): ?>
          <tr>
            <td><?php echo $person->name; ?></td>
            <td><?php echo $person->email; ?></td>
            <td><?php echo $person->title; ?></td>
            <td><?php echo $person->location; ?></td>
          </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </div>
</body>
</html>