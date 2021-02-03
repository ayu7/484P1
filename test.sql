-- photos
select * from project1.public_photo_information
minus
select * from view_photo_information;

select * from view_photo_information
minus
select * from project1.public_photo_information;

-- tag
select * from project1.public_tag_information
minus
select * from view_tag_information;

select * from view_tag_information
minus
select * from project1.public_tag_information;

-- events
select * from project1.public_event_information
minus
select * from view_event_information;

select * from view_event_information
minus
select * from project1.public_event_information;

-- user
select * from project1.public_user_information
minus
select * from view_user_information;

select * from view_user_information
minus
select * from project1.public_user_information;

-- friends
select least(user1_id, user2_id), greatest(user1_id, user2_id)
from project1.public_are_friends
minus
select least(user1_id, user2_id), greatest(user1_id, user2_id)
from view_are_friends;

select least(user1_id, user2_id), greatest(user1_id, user2_id)
from view_are_friends
minus
select least(user1_id, user2_id), greatest(user1_id, user2_id)
from project1.public_are_friends;
