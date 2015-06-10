(select c.id, "Mailing" as `type`, a.street, a.unit, a.city, a.region,
    a.postcode, a.county, a.country
from CProvider c
join Address a on a.id = c.practiceAddress)
union
(select c.id, "Practice" as `type`, a.street, a.unit, a.city, a.region,
    a.postcode, a.county, a.country
from CProvider c
join Address a on a.id = c.mailingAddress);
